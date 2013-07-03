###
# gettext for jQuery
#
# Copyright (c) 2008 Sabin Iacob (m0n5t3r) <iacobs@m0n5t3r.info>
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# @license http://www.gnu.org/licenses/gpl.html
# @project jquery.gettext
#
# Usage:
#
# This plugin expects its input data to be a JSON object like
# {"": header, "string": "translation", ...}
#
# After getting the server side set up (either as a static file - my choice - or
# as a web service), the client side is simple:
# add to the head section of the page something like
# <link href="path/to/translation.json" lang="ro" rel="gettext"/>
# in your script, use $.gt.gettext(string) or _(string); for plural forms, use
# $.gt.ngettext(sg, pl1[, pl2, ...], count) or n_(sg, pl1[, pl2, ...], count)
# to extract strings to a .po file, you can use standard gettext utilities like
# xgettext and msgfmt; to generate the JSON, one could use the following Python
# snippet, assuming a domain.mo file exists under path/lang/LC_MESSAGES:
#
# import simplejson as enc
#
# def gettext_json(domain, path, lang = [], indent = False):
# try:
# tr = gettext.translation(domain, path, lang)
# return enc.dumps(tr._catalog, ensure_ascii = False, indent = indent)
# except IOError:
# return None
#
# why go through the additional hassle of gettext? well, it's a matter of
# preference, the main advantags I see are:
# well known editing tools like KBabel, poEdit, gtranslator, Emacs PO mode,
# etc.
# translation memory, fuzzy matches and other features that get really
# helpful when your application is big and you have hundreds of strings
###
RE_PLURAL = ///
    ^
    Plural-Forms: \s*
    nplurals  \s* = \s* (\d+); \s*
    plural    \s* = \s* ([^a-zA-Z0-9\$]* ([a-zA-Z0-9\$]+).+)
    $
  ///m

isArray = (obj) ->
  typeof obj is 'object' and obj.constructor is Array

class Gettext
  @interpolate: (str, lang) ->
    str.replace(/:lang/g, lang)

  @ajaxPath: '/locale/:lang/LC_MESSAGES/default.json'

  @ajaxLoad: (file, success, error) ->
    xhr = jQuery.getJSON(file, (data) ->
      gt = new Gettext(data)
      success?.call this, gt
    )
    xhr.error error if error
    xhr

  @ajaxLoadLang: (lang, args...) ->
    @ajaxLoad @interpolate(@ajaxPath, lang), args...

  @fsPath: ''

  @loadFile: (file, callback) ->
    require('fs').readFile file, (err, json) =>
      return callback err if err
      try
        data = JSON.parse json
      catch e
        return callback e
      callback null, new @(data)

  @loadLangFile: (lang, callback) ->
    @loadFile @interpolate(@fsPath, lang), callback

  @loadFileSync: (file) ->
    new @(JSON.parse require('fs').readFileSync file)

  @loadLangFileSync: (lang) ->
    @loadFileSync @interpolate(@fsPath, lang)

  constructor: (@messages = {}) ->
    pl = RE_PLURAL.exec @messages[""]
    if pl
      np = pl[1]
      expr = pl[2]
      v = pl[3]
      try
        @plural = eval "(function(#{v}) {return #{expr};})"

  plural: (n) ->
    n isnt 1

  gettext: (msgstr) ->
    trans = @messages[msgstr]
    # console.log(trans)
    return trans if typeof trans is 'string' # regular action
    # the translation contains plural(s), yet gettext was called
    return trans[0] if isArray(trans)
    msgstr

  ngettext: (pls..., cnt) ->
    sg = pls[0]
    trans = @messages[sg] ? pls
    # called ngettext, but no plural forms available :-?
    return trans if typeof trans is 'string'
    if isArray trans
      pl = @plural(cnt)
      pl = (if pl then 1 else 0) if typeof pl is 'boolean' and pls.length is 2
      return trans[pl] if typeof pl is 'number' and pl < trans.length
    sg

if module?.exports
  module.exports = Gettext

if jQuery?
  do ($ = jQuery) ->
    $.Gettext = Gettext
    $.gt = new Gettext()
    lang  = $('html').attr('lang')
    link  = $("link[rel=\"gettext\"][lang=\"#{lang}\"]")
    if link.length
      Gettext.ajaxLoad link.attr('href'), (gt) -> $.gt = gt
