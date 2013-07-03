Javascript i18n using gettext, jQuery and Python
================================================

This toolkit uses a combination of gettext, a jQuery plugin and a Python script
to enable the internationalization of Javascript files.

This technique is to be used before deploying or commiting javascript code.
It take the form of a single console command which goes through multiple
parsing and conversion steps. After this command is executed, a JSON file is
available and can be used via a jQuery plugin.

## No js version
`cake build` to get it.

## mo2json-all
Will create json files for all domains for all languages in some folder.

Translations filename format: `:locales_dir/:language/LC_MESSAGES/:domain.mo`.

Requirements
------------

- [Gettext][]
- [Python 2.5 or later][Python] (not compatible with Python 3.x)


[Gettext]: http://www.gnu.org/software/gettext/
[Python]: http://www.python.org/


Sample javascript code
----------------------

```javascript
function write(txt) {
    $("#console").append(txt + "&lt;br/&gt;")
}
write(_("Humpty Dumpty sat on a wall,"));
write(_("Humpty Dumpty had a great fall."));
write(_("All the king's horses, And all the king's men,"));
write(_("Couldn't put Humpty together again."));
```


Setup needed in the HTML document
---------------------------------

```html
<html lang="fr">
    <link href="javascript.en.json" lang="en" rel="gettext" />
    <link href="javascript.fr.json" lang="fr" rel="gettext" />
```

```html
<script type="text/javascript" src="jquery.js"></script>
<script type="text/javascript" src="jquery.gettext.js"></script>
<script type="text/javascript">$.gt.load();</script>
<script type="text/javascript" src="test.js"></script>
```


Console command and expected output
-----------------------------------

```
C:\gettext> makemessages.bat
Extracting keys from javascript code
Merging new keys with existing keys
Converting message files to binary
0 translated messages, 4 untranslated messages.
4 translated messages.
Converting binary files to JSON
Removing temp files
```


Resulting JSON files
--------------------

```javascript
{
"": "Project-Id-Version: \nReport-Msgid-Bugs-To: \nPOT-Creation-Date: 2009-01-29 14:30-0500\nPO-Revision-Date: 2009-01-30 11:05-0500\nLast-Translator: John Doe <john.doe@shopmedia.com>\nLanguage-Team: fr <LL@li.org>\nMIME-Version: 1.0\nContent-Type: text/plain; charset=utf-8\nContent-Transfer-Encoding: 8bit\n", 
"Couldn't put Humpty together again.": "Ne purent jamais Remonter Humpty.", 
"Humpty Dumpty sat on a wall,": "Humpty Dumpty s'assit sur le mur,", 
"All the king's horses, And all the king's men,": "Tous les chevaux du roi, Et tous les soldats du roi", 
"Humpty Dumpty had a great fall.": "Humpty Dumpty se cassa la figure."
}
```