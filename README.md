#youdao-translate.el
-----
一个调用有道词典在线翻译API的Elisp扩展程序。

依赖：

 - grapnel（<https://github.com/leathekd/grapnel>）

#安装
-----
1、从Github上将代码clone到某目录（如~/.emacs.d）：

    $ cd ~/.emacs.d
    $ git clone https://github.com/1u4nx/youdao-translate.el.git youdao-translate

2、到<http://fanyi.youdao.com/openapi?path=data-mode>申请API Key。申请不需要审核，提交信息后马上就可以得到key。

3、在Emacs初始化脚本（~/.emacs或~/.emacs.d/init.el）中添加如下代码：

    (add-to-list 'load-path "~/.emacs.d/youdao-translate")
    (setq youdao-api-key "申请得到的Key")
    (setq youdao-api-keyfrom "申请得到的Keyfrom")
    (require 'youdao-translate)

#使用
-----
1、Mark要查询的单词（C-@或者C-Space）

2、执行：`M-x youdao-translate-word`

*注意：默认不支持快捷键（因为我不喜欢）。*
