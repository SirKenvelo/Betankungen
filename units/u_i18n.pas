{
  u_i18n.pas
  ---------------------------------------------------------------------------
  CREATED: 2026-03-07
  UPDATED: 2026-03-07
  AUTHOR : Christof Kempinski
  Minimales i18n-Skeleton fuer zentrale Sprachsteuerung und Lookup.

  Verantwortlichkeiten:
  - Definiert den Sprachraum (`de`, `en`, `pl`) als technische Basis.
  - Bietet den stabilen Message-Key-Contract (`TMsgId`).
  - Kapselt den zentralen Textzugriff ueber `Tr()`.
  - Stellt Normalisierung/Parsing fuer Sprachcodes bereit.

  Hinweis:
  - Diese Unit ist bewusst ein Skeleton. Breite Textmigration folgt spaeter.
  ---------------------------------------------------------------------------
}

unit u_i18n;

{$mode objfpc}{$H+}

interface

type
  TLanguage = (
    langDe,
    langEn,
    langPl
  );

  // Stabile Message-IDs fuer den i18n-Einstiegspunkt.
  TMsgId = (
    midI18nSkeletonReady,
    midConfigLanguageInvalid,
    midConfigLanguageDefaulted,
    midMetaConfigStatusHeader,
    midMetaConfigLanguageUnset,
    midMetaConfigStatusFooter,
    midMetaNoConfigToDelete,
    midMetaDbNotDeletedHint,
    midMetaFirstRunConfigCreatedFmt,
    midMetaFirstRunDbFmt,
    midMetaHelpHint,
    midMetaDatabaseCreated
  );

const
  DEFAULT_LANGUAGE = langDe;
  DEFAULT_LANGUAGE_CODE = 'de';

procedure SetLanguage(const ALang: TLanguage);
procedure SetLanguageByCodeOrDefault(const ACode: string; const AFallback: TLanguage = DEFAULT_LANGUAGE);
function GetLanguage: TLanguage;
function GetLanguageCode: string;

function ParseLanguageCode(const ACode: string; out ALang: TLanguage): boolean;
function NormalizeLanguageCode(const ACode: string): string;
function NormalizeLanguageCodeOrDefault(const ACode: string): string;

function Tr(const AMsgId: TMsgId): string;

implementation

uses
  SysUtils;

var
  GCurrentLanguage: TLanguage = DEFAULT_LANGUAGE;

function LanguageToCode(const ALang: TLanguage): string;
begin
  case ALang of
    langDe: Result := 'de';
    langEn: Result := 'en';
    langPl: Result := 'pl';
  else
    Result := DEFAULT_LANGUAGE_CODE;
  end;
end;

procedure SetLanguage(const ALang: TLanguage);
begin
  GCurrentLanguage := ALang;
end;

procedure SetLanguageByCodeOrDefault(const ACode: string; const AFallback: TLanguage = DEFAULT_LANGUAGE);
var
  L: TLanguage;
begin
  if ParseLanguageCode(ACode, L) then
    GCurrentLanguage := L
  else
    GCurrentLanguage := AFallback;
end;

function GetLanguage: TLanguage;
begin
  Result := GCurrentLanguage;
end;

function GetLanguageCode: string;
begin
  Result := LanguageToCode(GCurrentLanguage);
end;

function ParseLanguageCode(const ACode: string; out ALang: TLanguage): boolean;
var
  S: string;
begin
  S := LowerCase(Trim(ACode));
  if S = 'de' then
  begin
    ALang := langDe;
    Exit(True);
  end;
  if S = 'en' then
  begin
    ALang := langEn;
    Exit(True);
  end;
  if S = 'pl' then
  begin
    ALang := langPl;
    Exit(True);
  end;
  Result := False;
end;

function NormalizeLanguageCode(const ACode: string): string;
var
  L: TLanguage;
begin
  if ParseLanguageCode(ACode, L) then
    Result := LanguageToCode(L)
  else
    Result := '';
end;

function NormalizeLanguageCodeOrDefault(const ACode: string): string;
begin
  Result := NormalizeLanguageCode(ACode);
  if Result = '' then
    Result := DEFAULT_LANGUAGE_CODE;
end;

function TrDe(const AMsgId: TMsgId): string;
begin
  case AMsgId of
    midI18nSkeletonReady:
      Result := 'i18n-Skeleton aktiv.';
    midConfigLanguageInvalid:
      Result := 'Config language ist ungueltig; fallback auf Default.';
    midConfigLanguageDefaulted:
      Result := 'Config language fehlt; Default wurde gesetzt.';
    midMetaConfigStatusHeader:
      Result := '--- Betankungen: Config-Status ---';
    midMetaConfigLanguageUnset:
      Result := 'Config Sprache:     (nicht gesetzt; default=de)';
    midMetaConfigStatusFooter:
      Result := '---------------------------------';
    midMetaNoConfigToDelete:
      Result := 'Keine Config vorhanden (nichts zu loeschen).';
    midMetaDbNotDeletedHint:
      Result := 'Hinweis: Die DB-Datei wurde NICHT geloescht.';
    midMetaFirstRunConfigCreatedFmt:
      Result := 'Erststart: Config angelegt: %s';
    midMetaFirstRunDbFmt:
      Result := 'Erststart: DB: %s';
    midMetaHelpHint:
      Result := 'Tipp: Betankungen --help';
    midMetaDatabaseCreated:
      Result := 'Datenbank angelegt';
  else
    Result := '';
  end;
end;

function TrEn(const AMsgId: TMsgId): string;
begin
  case AMsgId of
    midI18nSkeletonReady:
      Result := 'i18n skeleton active.';
    midConfigLanguageInvalid:
      Result := 'Config language is invalid; fallback to default.';
    midConfigLanguageDefaulted:
      Result := 'Config language missing; default was set.';
    midMetaConfigStatusHeader:
      Result := '--- Betankungen: Config status ---';
    midMetaConfigLanguageUnset:
      Result := 'Config language:    (not set; default=de)';
    midMetaConfigStatusFooter:
      Result := '-------------------------------';
    midMetaNoConfigToDelete:
      Result := 'No config present (nothing to delete).';
    midMetaDbNotDeletedHint:
      Result := 'Hint: The DB file was NOT deleted.';
    midMetaFirstRunConfigCreatedFmt:
      Result := 'First run: Config created: %s';
    midMetaFirstRunDbFmt:
      Result := 'First run: DB: %s';
    midMetaHelpHint:
      Result := 'Hint: Betankungen --help';
    midMetaDatabaseCreated:
      Result := 'Database created';
  else
    Result := '';
  end;
end;

function TrPl(const AMsgId: TMsgId): string;
begin
  case AMsgId of
    midI18nSkeletonReady:
      Result := 'Szkielet i18n aktywny.';
    midConfigLanguageInvalid:
      Result := 'Jezyk w config jest nieprawidlowy; fallback na domyslny.';
    midConfigLanguageDefaulted:
      Result := 'Brak jezyka w config; ustawiono domyslny.';
    midMetaConfigStatusHeader:
      Result := '--- Betankungen: Status konfiguracji ---';
    midMetaConfigLanguageUnset:
      Result := 'Jezyk config:       (brak; domyslny=de)';
    midMetaConfigStatusFooter:
      Result := '---------------------------------------';
    midMetaNoConfigToDelete:
      Result := 'Brak konfiguracji (nic do usuniecia).';
    midMetaDbNotDeletedHint:
      Result := 'Wskazowka: Plik DB NIE zostal usuniety.';
    midMetaFirstRunConfigCreatedFmt:
      Result := 'Pierwsze uruchomienie: Config utworzony: %s';
    midMetaFirstRunDbFmt:
      Result := 'Pierwsze uruchomienie: DB: %s';
    midMetaHelpHint:
      Result := 'Wskazowka: Betankungen --help';
    midMetaDatabaseCreated:
      Result := 'Baza danych utworzona';
  else
    Result := '';
  end;
end;

function Tr(const AMsgId: TMsgId): string;
begin
  case GCurrentLanguage of
    langDe: Result := TrDe(AMsgId);
    langEn: Result := TrEn(AMsgId);
    langPl: Result := TrPl(AMsgId);
  else
    Result := TrDe(AMsgId);
  end;
end;

end.
