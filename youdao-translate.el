;;; An Emacs plugin for using the Youdao Translate API.
;; youdao-translate.el ---

;; Copyright (C) 2022 lu4nx

;; Author: lu4nx <lx@shellcodes.org>
;; URL: https://github.com/lu4nx/youdao-translate.el
;; Created: October 24, 2014
;; Update: December 11, 2022
;; Version: v0.2
;; License: GPLv3
;; Keywords: elisp, youdao, translate


;;; Code:

(require 'xml)

(defun youdao-translate-word ()
  "Query the marked word."
  (interactive)
  (let* ((mark-pos (mark))
         (point-pos (point))
         (word (buffer-substring-no-properties mark-pos point-pos)))
    (youdao-online-translate word)))

(defun youdao-input->translate (word)
  "Input a word and query."
  (interactive "sInput a word: ")
  (youdao-online-translate word))

(defun show-translate-result (basic-data)
  (when (not basic-data)
    (princ "data error"))
  (let* ((root (with-temp-buffer (insert basic-data)
                                 (xml-parse-region (point-min) (point-max))))
         (xml-data (car root))
         (custom-translation (car (xml-get-children xml-data 'custom-translation)))
         (translation (car (xml-get-children custom-translation 'translation)))
         (content (car (xml-get-children translation 'content)))
         (text (car (xml-node-children content))))
    (message
     (with-output-to-string
       (if (null text)
           (princ "Not found.")
         (princ (format "基本释义：\n%s\n" (decode-coding-string text 'utf-8))))))))

(defun url->content (url)
  (with-current-buffer
      (url-retrieve-synchronously url)
    (goto-char (point-min))
    (re-search-forward "^$")
    (delete-region (point) (point-min))
    (kill-line)
    (buffer-string)))

(defun youdao-online-translate (word)
  (let* ((api-url (format "https://dict.youdao.com/fsearch?client=deskdict&keyfrom=chrome.extension&q=%s&pos=-1
&doctype=xml&xmlVersion=3.2&dogVersion=1.0&vendor=unknown&appVer=3.1.17.4208&le=eng"
                          word))
         (data (url->content api-url)))
    (show-translate-result data)))

(provide 'youdao-translate)

;;; youdao-translate.el ends here
