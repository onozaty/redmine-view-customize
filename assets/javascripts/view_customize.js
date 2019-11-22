'use strict';

(function ($) {
  $(document).ready(function () {
    let typeSelector = $('#view_customize_customize_type');
    let typeOptions = function (opt) {
      let options = {
        javascript: {
          mode: {name: "javascript", globalVars: true},
        },
        css: {
          mode: 'css'
        },
        html: {
          mode: 'htmlmixed'
        }
      };

      return opt ? options[typeSelector.val()][opt] : options[typeSelector.val()];
    };

    let codeEditor = CodeMirror.fromTextArea(document.getElementById('view_customize_code'), Object.assign(
      {
        lineNumbers: true,
        extraKeys: {
          "Ctrl-Space": "autocomplete",
          "Ctrl-Q": function (cm) {
            cm.foldCode(cm.getCursor());
          }
        },
        mode: {name: "javascript", globalVars: true},
        tabSize: 2,
        matchBrackets: true,
        autoCloseBrackets: true,
        matchTags: true,
        autoCloseTags: true,
        foldGutter: true,
        gutters: ["CodeMirror-linenumbers", "CodeMirror-foldgutter", "CodeMirror-lint-markers"],
        lint: true,
        styleActiveLine: true
      },
      typeOptions()
    ));

    typeSelector.on('change', function () {
      for (let opt in typeOptions()) {
        codeEditor.setOption(opt, typeOptions(opt))
      }
    });
  })
})(jQuery);
