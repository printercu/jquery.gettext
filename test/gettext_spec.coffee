assert  = require 'assert'
Gettext = require '../'

describe 'Gettext', ->
  describe 'when translates', ->
    describe 'if no translations given', ->
      before ->
        @gt = new Gettext

      it 'returns given message as translation', ->
        assert.equal @gt.gettext('test'), 'test'

      it 'returns given messages as plural translations', ->
        assert.equal @gt.ngettext('test', 1), 'test'
        assert.equal @gt.ngettext('test', 'test2', 1), 'test'
        assert.equal @gt.ngettext('test', 'test2', 2), 'test2'
        assert.equal @gt.ngettext('test', 'test2', 53), 'test2'

    describe 'if no translations given', ->
      before ->
        @gt = new Gettext
          test:   't_test'
          plural: ['t_plural', 't_plural2']

      it 'returns given message as translation', ->
        assert.equal @gt.gettext('test'), 't_test'

      it 'returns given messages as plural translations', ->
        assert.equal @gt.ngettext('test', 1), 't_test'
        assert.equal @gt.ngettext('plural', 'plural2', 1), 't_plural'
        assert.equal @gt.ngettext('plural', 'plural2', 2), 't_plural2'
        assert.equal @gt.ngettext('plural', 'plural2', 53), 't_plural2'

    describe 'when plural expression is given', ->
      before ->
        @gt = new Gettext

      it 'should use this expression'
