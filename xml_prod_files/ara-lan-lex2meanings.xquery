(:
  Copyright 2008-2010 Cantus Foundation
  http://alpheios.net

  This file is part of Alpheios.

  Alpheios is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  Alpheios is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 :)

(:
  XQuery to extract short definitions from Lane Arabic lexicon

  Output is in form
  <entrylist id="ara-lan">
    <entry id="$id">
      <lemma>$lemma</lemma>
      <meaning>$definition</meaning>
    </entry>
    ...
  </entrylist.
 :)

(: external variables :)

declare variable $e_dir external;

(: file global variables :)
declare variable $f_lang := "ara";
declare variable $f_code := "lan";

declare variable $f_entries := collection($e_dir)//entryFree;

(: wrap everything in <entrylist> :)
element entrylist
{
  attribute id { concat($f_lang, "-", $f_code) },

  (: for each entry in file :)
  for $entry in $f_entries
  (: for each orth in entry :)
  let $keys :=
    distinct-values(
      for $key in $entry//orth[@lang eq "ar"]
      return normalize-space($key/text())
    )
  for $key in $keys
  (: put out entry :)
  return
    element entry
    {
      $entry/@id,
      element lemma { $key }
    }
}
