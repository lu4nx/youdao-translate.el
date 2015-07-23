;;; youdao-translate.el ---

;; Copyright (C) 2014  lu4nx

;; Author: lu4nx <lx@shellcodes.org>
;; Date: 2014-10-24

(require 'cl)
(require 'json)
(require 'grapnel)

(defun youdao-translate-word ()
  "查询被Mark的单词"
  (interactive)
  (youdao-online-translate (buffer-substring-no-properties (mark) (point))))

(defun youdao-input->translate (word)
  "查询用户输入的单词"
  (interactive "sInput a word: ")
  (youdao-online-translate word))

(defun show-basic-result (basic-data)
  (message
   (with-output-to-string
     (princ (format "英式发音：%s\n美式发音：%s\n"
                    (cdr (assoc 'uk-phonetic basic-data))
                    (cdr (assoc 'us-phonetic basic-data))))
     (princ "基本释义：\n")
     (loop for explain across (cdr (assoc 'explains basic-data))
           do
           (princ (format "%s\n" explain))))))

(defun youdao-online-translate (word)
  (grapnel-retrieve-url
   "http://fanyi.youdao.com/openapi.do"
   '((success . (lambda (res hdrs)
                  (let ((json-data (json-read-from-string res)))
                    (show-basic-result (cdr (assoc 'basic json-data))))))
     (failure . (lambda (res hdrs) (message "查询失败：%s" res)))
     (error . (lambda (res err)  (message "查询错误：%s" err))))
   "GET"
   (list (cons 'keyfrom youdao-api-keyfrom)
         (cons 'key youdao-api-key)
         '(type . "data")
         '(doctype . "json")
         '(version . "1.1")
         (cons 'q word))))

(provide 'youdao-translate)
