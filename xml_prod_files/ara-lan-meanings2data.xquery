(:
  Copyright 2008-2010 Cantus Foundation, The Alpheios Project, Ltd.
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
declare namespace  util="http://exist-db.org/xquery/util";

declare variable $e_docname external;
declare variable $e_output external;
declare option exist:serialize "indent=no";

let $doc := doc($e_docname)

return
  (: if putting out ids :)
  if ($e_output eq "ids")
  then
      element idlist {
        let $keys :=
        (: for each entry with an id :)
        for $entry at $i in $doc//entry
        for $i in 1 to 7
        (:let $key := saxon:evaluate(concat("$p1/lemma/@key", $i), $entry):)
        let $key := util:eval(concat("$entry/lemma/@key", $i)) 
        where $entry/@id and $key
        return
          <key>{concat($key, '|', $entry/@id)}</key>
        for $key in distinct-values($keys)
        order by xs:string($key) ascending
        return concat(normalize-space($key), '&#x000A;')
    }
  (: if putting out server-side index :)
  else if ($e_output eq "index")
  then
    element entrylist
    {
      (: for each entry with an id :)
      for $entry at $i in $doc//entry
      for $i in 1 to 7
      (:let $key := saxon:evaluate(concat("$p1/lemma/@key", $i), $entry):)
      let $key := util:eval(concat("$entry/lemma/@key", $i)) 
      where $entry/@id and $key
      return
        element entry
        {
          attribute lemma { $entry/lemma },
          attribute key { $key },
          attribute id { $entry/@id },
          attribute i { $i }
        }
    }

  else
    ("Unrecognized output option ", $e_output) 