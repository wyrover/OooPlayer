﻿{ *
  * Copyright (C) 2014-2016 ozok <ozok26@gmail.com>
  *
  * This file is part of OooPlayer.
  *
  * OooPlayer is free software: you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation, either version 2 of the License, or
  * (at your option) any later version.
  *
  * OooPlayer is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
  * along with OooPlayer.  If not, see <http://www.gnu.org/licenses/>.
  *
  * }
unit UnitLyricDownloader;

interface

uses
  System.Classes, IdBaseComponent, IdThreadComponent, StrUtils, SysUtils,
  IdThread, JvComponentBase, JvUrlListGrabber, JvUrlGrabbers, JvTypes, Rest.Utils;

type
  TLyricDownloaderStatus = (lsDownloading = 0, lsDone = 1, lsError = 2, lsIdle = 3);

type
  TItemInfo = class
    Title, Artist, Album: string;
  end;

type
  TLyricDownloader = class
  private
    FThread: TIdThreadComponent;
    FPageDownloader: TJvHttpUrlGrabber;
    FTitle: string;
    FArtist: string;
    FAlbum: string;
    FStatus: TLyricDownloaderStatus;
    FLyricFile: TStringList;
    FLyricFolder: string;
    FLyricStatusMsg: string;
    FLogLine: string;
    FItemInfo: TItemInfo;
    FDef: TJvCustomUrlGrabberDefaultProperties;
    FLyricSourceIndex: integer;

    // thread events
    procedure ThreadRun(Sender: TIdThreadComponent);
    procedure ThreadStopped(Sender: TIdThreadComponent);
    procedure ThreadTerminate(Sender: TIdThreadComponent);
    procedure DoneStream(Sender: TObject; Stream: TStream; StreamSize: Integer; Url: string);
    procedure Error(Sender: TObject; ErrorMsg: string);
    function FixStrings(const Str: string): string;
    function FixLine(const Str: string): string;
    procedure UpdateMainUI;
    procedure UpdateLyricStatus;
    procedure AddToLog;
    procedure EnableUIControls;
  public
    property SongTitle: string read FTitle write FTitle;
    property Artist: string read FArtist write FArtist;
    property Album: string read FAlbum write FAlbum;
    property Status: TLyricDownloaderStatus read FStatus;
    property Lyrics: TStringList read FLyricFile;
    property ItemInfo: TItemInfo read FItemInfo write FItemInfo;
    procedure Start;
    procedure Stop;
    constructor Create(const LyricFolder: string);
    destructor Destroy; override;
  end;

implementation

{ TLyricDownloader }

uses
  UnitMain, UnitLog, UnitSettings;

procedure TLyricDownloader.AddToLog;
begin
  LogForm.LogList.Lines.Add(FLogLine);
end;

constructor TLyricDownloader.Create(const LyricFolder: string);
begin
  FStatus := lsIdle;

  FThread := TIdThreadComponent.Create;
  FThread.Priority := tpIdle;
  FThread.StopMode := smTerminate;
  FThread.OnRun := ThreadRun;
  FThread.OnStopped := ThreadStopped;
  FThread.OnTerminate := ThreadTerminate;

  FDef := TJvCustomUrlGrabberDefaultProperties.Create(nil);
  FPageDownloader := TJvHttpUrlGrabber.Create(nil, '', FDef);
  with FPageDownloader do
  begin
    OnDoneStream := DoneStream;
    OnError := Error;
    OutputMode := omStream;
    Agent := 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.87 Safari/537.36 OPR/36.0.2130.46';
  end;

  FLyricFolder := LyricFolder;
  FLyricFile := TStringList.Create;
  FItemInfo := TItemInfo.Create;
end;

destructor TLyricDownloader.Destroy;
begin
  try
    FThread.Free;
  except

  end;
  FPageDownloader.Free;
  FLyricFile.Free;
  FItemInfo.Free;
  FDef.Free;
end;

procedure TLyricDownloader.DoneStream(Sender: TObject; Stream: TStream; StreamSize: Integer; Url: string);
const
  START_STR = '<!-- Usage of azlyrics.com content';
  END_STR = '<!-- MxM banner -->';
  START_STR_BAT = '<pre id="from_pre">';
  END_STR_BAT = '<pre id="to_pre" style="display';
  BAT_SPAN = '<span style="font-size';
  METRO_START = '<div id="lyrics-body-text" class="js-lyric-text">';
  // METRO_END = '<div id="selected-song-meaning-open" unselectable="on" style="display:none;">';
  METRO_END = '<p class="writers"><strong>Songwriters</strong>';
  METRO_END2 = '</sd-lyricbody>';
  LRC123_START = '<font color="#008000">';
var
  LSR: TStreamReader;
  LLine: string;
  LAddToLyricFile: Boolean;
  I: integer;
begin
  if Stream.Size = 0 then
  begin
    FLyricStatusMsg := 'Downloaded file is empty';
    try
      FThread.Synchronize(UpdateLyricStatus);
    except

    end;
    try
      FThread.Synchronize(EnableUIControls);
    except

    end;
    if SettingsForm.LogLyricFailBtn.Checked then
    begin
      FLogLine := 'Failed to download lyric from ' + FPageDownloader.Url;
      try
        FThread.Synchronize(AddToLog);
      except

      end;
    end;
    FStatus := lsError;
  end
  else
  begin
    LAddToLyricFile := False;
    LSR := TStreamReader.Create(Stream, TEncoding.UTF8);
    try
      try
        case FLyricSourceIndex of
          0: // az
            begin
              while not LSR.EndOfStream do
              begin
                try
                  LLine := Trim(LSR.ReadLine);
                except

                end;
                if LLine.StartsWith(START_STR) then
                begin
                  LAddToLyricFile := True;
                end
                else if LLine = END_STR then
                begin
                  Break;
                end;
                if LAddToLyricFile and (not LLine.StartsWith(START_STR)) then
                begin
                  FLyricFile.Add(Trim(FixLine(LLine)));
                end;
              end;
            end;
          1: // bat
            begin
              while not LSR.EndOfStream do
              begin
                try
                  LLine := Trim(LSR.ReadLine);
                except

                end;
                if Copy(LLine, 1, Length(START_STR_BAT)) = START_STR_BAT then
                begin
                  LAddToLyricFile := True;
                end
                else if Copy(LLine, 1, Length(END_STR_BAT)) = END_STR_BAT then
                begin
                  Break;
                end;
                if LAddToLyricFile then
                begin
                  if Copy(LLine, 1, Length(BAT_SPAN)) <> BAT_SPAN then
                  begin
                    FLyricFile.Add(Trim(FixLine(LLine)));
                  end;
                end;
              end;
            end;
          2: // metro
            begin
              while not LSR.EndOfStream do
              begin
                try
                  LLine := Trim(LSR.ReadLine);
                except

                end;
                if LLine = METRO_START then
                begin
                  LAddToLyricFile := True;
                end
                else if LLine.StartsWith(METRO_END) or LLine.StartsWith(METRO_END2) then
                begin
                  Break;
                end;
                if LAddToLyricFile then
                begin
                  FLyricFile.Add(Trim(FixLine(LLine)));
                end;
              end;
            end;
        end;
      except
        on E: Exception do
          LogForm.LogList.Lines.Add('Lyric downloader error: ' + E.Message)
      end;

    finally
      LSR.Close;
      LSR.Free;
    end;

    // remove first line for metro
    if FLyricSourceIndex = 2 then
    begin
      if FLyricFile.Count > 1 then
      begin
        FLyricFile.Delete(0);
      end;
    end;

    // remove empty lines from bottom
    for I := FLyricFile.Count - 1 downto 0 do
    begin
      if Trim(FLyricFile[i]) = '' then
      begin
        FLyricFile.Delete(i);
      end;
    end;
    // remove empty lines from bottom
    if FLyricFile.Count > 0 then
    begin
      while Length(Trim(FLyricFile[0])) < 1 do
      begin
        FLyricFile.Delete(0);
      end;
    end;
    // show lyric on the interface
    try
      FThread.Synchronize(UpdateMainUI);
    except

    end;
    if FLyricFile.Count > 1 then
    begin
      with FItemInfo do
      begin
        try

          FLyricFile.SaveToFile(FLyricFolder + MainForm.CreateLyricFileName(Title, Artist, Album), TEncoding.UTF8);
        except
          on E: EFCreateError do
          begin
            FLyricStatusMsg := 'Loaded downloaded lyric but cannot save to file ' + MainForm.CreateLyricFileName(Title, Artist, Album) + '.txt';
            try
              FThread.Synchronize(UpdateLyricStatus);
            except

            end;
          end;
        end;
      end;
    end
    else
    begin
      FLyricStatusMsg := 'Could not find any lyrics';
      try
        FThread.Synchronize(UpdateLyricStatus);
      except

      end;
      if SettingsForm.LogLyricFailBtn.Checked then
      begin
        FLogLine := 'Failed to download lyric from ' + FPageDownloader.Url;
        try
          FThread.Synchronize(AddToLog);
        except

        end;
      end;
    end;

    try
      FThread.Synchronize(EnableUIControls);
    except

    end;
    FStatus := lsDone;
  end;
end;

procedure TLyricDownloader.EnableUIControls;
begin
  with MainForm do
  begin
    LyricTitleEdit.Text := FTitle;
    LyricArtistEdit.Text := FArtist;
    FLyricAlbumStr := FAlbum;
    LyricSearchBtn.Enabled := True;
    LyricArtistEdit.Enabled := True;
    LyricTitleEdit.Enabled := True;
    LyricSourceList.Enabled := True;
    ReloadLyricTitleBtn.Enabled := True;
  end;
end;

procedure TLyricDownloader.Error(Sender: TObject; ErrorMsg: string);
begin
  FStatus := lsError;
  FLyricStatusMsg := 'Lyric downloader error msg: ' + ErrorMsg;
  try
    FThread.Synchronize(UpdateLyricStatus);
  except

  end;
  try
    FThread.Synchronize(EnableUIControls);
  except

  end;
end;

function TLyricDownloader.FixLine(const Str: string): string;
begin
  Result := Str;

  Result := Trim(StringReplace(Result, '<div id="lyrics-body-text">', '', [rfReplaceAll]));
  Result := Trim(StringReplace(Result, '</p><p class=''verse''>', sLineBreak, [rfReplaceAll]));
  Result := Trim(StringReplace(Result, '<p class=''verse''>', sLineBreak, [rfReplaceAll]));
  Result := Trim(StringReplace(Result, '<p class=''''verse''''> ', sLineBreak, [rfReplaceAll]));
  Result := Trim(StringReplace(Result, '</p>	</div>', '', [rfReplaceAll]));
  Result := Trim(StringReplace(Result, '<br />', sLineBreak, [rfReplaceAll]));
  Result := Trim(StringReplace(Result, '<i>', '', [rfReplaceAll]));
  Result := Trim(StringReplace(Result, '</div>', '', [rfReplaceAll]));
  Result := Trim(StringReplace(Result, '</i>', '', [rfReplaceAll]));
  Result := Trim(StringReplace(Result, '<!-- start of lyrics -->', '', [rfReplaceAll]));
  Result := Trim(StringReplace(Result, '<pre id="from_pre">', '', [rfReplaceAll]));
  Result := Trim(StringReplace(Result, '</pre>', '', [rfReplaceAll]));
  Result := Trim(StringReplace(Result, '<br/>', sLineBreak, [rfReplaceAll]));
  Result := Trim(StringReplace(Result, 'º', 'ş', [rfReplaceAll]));
  Result := Trim(StringReplace(Result, 'þ', 'ş', [rfReplaceAll]));
  Result := Trim(StringReplace(Result, '<br>', sLineBreak, [rfReplaceAll]));
  Result := Trim(StringReplace(Result, '&quot;', '"', [rfReplaceAll]));

  Result := Trim(Result)
end;

function TLyricDownloader.FixStrings(const Str: string): string;
begin
  case FLyricSourceIndex of
    0: // azlyrics
      begin
        Result := LowerCase(StringReplace(Str, ' ', '', [rfReplaceAll]));
        Result := LowerCase(StringReplace(Result, '&', '', [rfReplaceAll]));
        Result := LowerCase(StringReplace(Result, 'Ö', 'o', [rfReplaceAll]));
        Result := LowerCase(StringReplace(Result, 'ö', 'o', [rfReplaceAll]));
        Result := LowerCase(StringReplace(Result, '''', '', [rfReplaceAll]));
        Result := Trim(StringReplace(Result, ',', '', [rfReplaceAll]));
        Result := Trim(StringReplace(Result, '!', '', [rfReplaceAll]));
        Result := Trim(StringReplace(Result, '?', '', [rfReplaceAll]));
        Result := Trim(StringReplace(Result, '(', '', [rfReplaceAll]));
        Result := Trim(StringReplace(Result, ')', '', [rfReplaceAll]));
        Result := Trim(StringReplace(Result, '[', '', [rfReplaceAll]));
        Result := Trim(StringReplace(Result, ']', '', [rfReplaceAll]));
        Result := Trim(StringReplace(Result, '-', '', [rfReplaceAll]));
        Result := Trim(StringReplace(Result, '.', '', [rfReplaceAll]));
      end;
    1: // batlyrics
      begin
        Result := LowerCase(StringReplace(Str, ' & ', 'and', [rfReplaceAll]));
        Result := LowerCase(StringReplace(Result, ' ', '_', [rfReplaceAll]));
        Result := LowerCase(StringReplace(Result, 'Ö', 'o', [rfReplaceAll]));
        Result := LowerCase(StringReplace(Result, 'ö', 'o', [rfReplaceAll]));
        Result := Trim(StringReplace(Result, ',', '', [rfReplaceAll]));
        Result := Trim(StringReplace(Result, '!', '', [rfReplaceAll]));
        Result := Trim(StringReplace(Result, '?', '', [rfReplaceAll]));
        Result := Trim(StringReplace(Result, '[', '', [rfReplaceAll]));
        Result := Trim(StringReplace(Result, ']', '', [rfReplaceAll]));
        Result := Trim(StringReplace(Result, '.', '', [rfReplaceAll]));
      end;
    2: // metrolyrics
      begin
        Result := LowerCase(StringReplace(Str, ' & ', '-', [rfReplaceAll]));
        Result := LowerCase(StringReplace(Result, ' ', '-', [rfReplaceAll]));
        Result := LowerCase(StringReplace(Result, 'Ö', 'o', [rfReplaceAll]));
        Result := LowerCase(StringReplace(Result, 'ö', 'o', [rfReplaceAll]));
        Result := LowerCase(StringReplace(Result, '''', '', [rfReplaceAll]));
        Result := Trim(StringReplace(Result, ',', '', [rfReplaceAll]));
        Result := Trim(StringReplace(Result, '!', '', [rfReplaceAll]));
        Result := Trim(StringReplace(Result, '?', '', [rfReplaceAll]));
        Result := Trim(StringReplace(Result, '(', '', [rfReplaceAll]));
        Result := Trim(StringReplace(Result, ')', '', [rfReplaceAll]));
        Result := Trim(StringReplace(Result, '[', '', [rfReplaceAll]));
        Result := Trim(StringReplace(Result, ']', '', [rfReplaceAll]));
        Result := Trim(StringReplace(Result, '.', '', [rfReplaceAll]));
      end;
    3: // lrc123
      begin
        Result := LowerCase(StringReplace(Str, ' ', '+', [rfReplaceAll]));
        Result := LowerCase(StringReplace(Result, ' & ', '-', [rfReplaceAll]));
        Result := LowerCase(StringReplace(Result, ' ', '-', [rfReplaceAll]));
        Result := LowerCase(StringReplace(Result, 'Ö', 'o', [rfReplaceAll]));
        Result := LowerCase(StringReplace(Result, 'ö', 'o', [rfReplaceAll]));
        Result := LowerCase(StringReplace(Result, '''', '', [rfReplaceAll]));
        Result := Trim(StringReplace(Result, ',', '', [rfReplaceAll]));
        Result := Trim(StringReplace(Result, '!', '', [rfReplaceAll]));
        Result := Trim(StringReplace(Result, '?', '', [rfReplaceAll]));
        Result := Trim(StringReplace(Result, '(', '', [rfReplaceAll]));
        Result := Trim(StringReplace(Result, ')', '', [rfReplaceAll]));
        Result := Trim(StringReplace(Result, '[', '', [rfReplaceAll]));
        Result := Trim(StringReplace(Result, ']', '', [rfReplaceAll]));
        Result := Trim(StringReplace(Result, '.', '', [rfReplaceAll]));
      end;
  end;
end;

procedure TLyricDownloader.Start;
begin
  FStatus := lsDownloading;
  if 'the ' = LowerCase(Copy(FArtist, 1, 4)) then
  begin
    FArtist := Trim(Copy(FArtist, 4, Maxint))
  end;
  FLyricFile.Clear;
  try
    FThread.Start;
  except
    on E: Exception do
    begin
      FStatus := lsDone;
    end;
  end;
end;

procedure TLyricDownloader.Stop;
begin
  if not FThread.Stopped then
  begin
    try
      FThread.Terminate;
      while not FThread.Terminated do
      begin
        FThread.TerminateAndWaitFor;
        Sleep(50);
      end;
    except

    end;
    FStatus := lsDone;
  end;
end;

procedure TLyricDownloader.ThreadRun(Sender: TIdThreadComponent);
begin
  FLyricStatusMsg := 'Searching...';
  try
    FThread.Synchronize(UpdateLyricStatus);
  except

  end;
  FLyricSourceIndex := MainForm.LyricSourceList.ItemIndex;
  case FLyricSourceIndex of
    0:
      FPageDownloader.Url := 'http://www.azlyrics.com/lyrics/' + URIEncode(FixStrings(FArtist) + '/' + FixStrings(FTitle)) + '.html';
    1:
      FPageDownloader.Url := 'http://batlyrics.net/' + URIEncode(FixStrings(FTitle) + '-lyrics-' + FixStrings(FArtist)) + '.html';
    2:
      FPageDownloader.Url := 'http://www.metrolyrics.com/' + URIEncode(FixStrings(FTitle) + '-lyrics-' + FixStrings(FArtist)) + '.html';
  end;

  FPageDownloader.Start;
  while FPageDownloader.Status <> gsStopped do
  begin
    Sleep(100);
  end;
  try
    FThread.Terminate;
  except

  end;
end;

procedure TLyricDownloader.ThreadStopped(Sender: TIdThreadComponent);
begin
  FStatus := lsDone;
end;

procedure TLyricDownloader.ThreadTerminate(Sender: TIdThreadComponent);
begin
  FStatus := lsDone;
end;

procedure TLyricDownloader.UpdateLyricStatus;
begin
  MainForm.LyricStatusLabel.Caption := FLyricStatusMsg;
end;

procedure TLyricDownloader.UpdateMainUI;
var
  I: Integer;
begin
  // if (MainForm.FPlaylists[MainForm.FSelectedPlaylistIndex][MainForm.FCurrentRadioIndex].Title = FTitle) and
  // (MainForm.FPlaylists[MainForm.FSelectedPlaylistIndex][MainForm.FCurrentRadioIndex].Artist = FArtist) then
  // begin
  MainForm.LyricList.Items.BeginUpdate;
  try
    if FLyricFile.Count > 0 then
    begin
      MainForm.LyricList.Items.Clear;
      for I := 0 to FLyricFile.Count - 1 do
      begin
        MainForm.LyricList.Items.Add(Trim(FLyricFile[i]));
      end;
    end;
  finally
    MainForm.UpdateLyricBoxWidth;
    MainForm.LyricList.Items.EndUpdate;
  end;
  if FLyricFile.Count > 1 then
  begin
    MainForm.LyricStatusLabel.Caption := 'Loaded downloaded lyric';
  end;
  // end
  // else
  // begin
  // if FLyricFile.Count > 1 then
  // begin
  // MainForm.LyricStatusLabel.Caption := 'Could not load lyrics';
  // end;
  // end;
end;

end.

