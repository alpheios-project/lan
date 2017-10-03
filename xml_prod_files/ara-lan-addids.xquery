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
  XQuery to add ids to entries in Salmone Arabic lexicon
 :)

(: file global variables :)
declare variable $f_doc := doc("/sgml/lexica/ara/sal/salmone.xml");

declare function local:count(
  $a_element as element()) as xs:integer
{
  if (string(node-name($a_element)) = "entryFree")
  then
    1
  else
    sum(
      for $child at $i in $a_element/node()
      return
        if ($child instance of element())
        then
          local:count($child)
        else 0
    )
};

declare function local:copy(
  $a_element as element(),
  $a_count as xs:integer) as element()
{
  element {node-name($a_element)}
  {
    (: if this is an entry, add id attribute :)
    if (string(node-name($a_element)) = "entryFree")
    then
      attribute id { concat('n', $a_count) }
    else (),

    (: copy attributes, but not TEI additions :)
    for $attr in $a_element/@*
    let $attr-name := string(node-name($attr))
    return
      if (not($attr-name = ("TEIform", "opt", "default")))
      then
        $attr
      else (),

    (: recurse :)
    let $counts :=
      for $child in $a_element/node()
      return
        if ($child instance of element())
        then
          local:count($child)
        else 0
    for $child at $i in $a_element/node()
    return
      if ($child instance of element())
      then
        local:copy($child, $a_count + sum(subsequence($counts, 1, $i - 1)))
      else
        $child
  }
};

local:copy($f_doc/*, 0)
