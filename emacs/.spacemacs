;; -*- mode: emacs-lisp -*-
(defun dotspacemacs/layers ()
  (setq-default
   dotspacemacs-distribution 'spacemacs
   dotspacemacs-enable-lazy-installation `unused
   dotspacemacs-ask-for-lazy-installation t
   dotspacemacs-configuration-layer-path '()
   dotspacemacs-configuration-layers
   '(
     ivy
     docker
     git
     github
     version-control
     restclient
     (multiple-cursors :variables multiple-cursors-backend 'evil-mc)
     ;; (markdown :variables markdown-live-preview-engine 'vmd)
     (shell :variables
            shell-default-height 30
            shell-default-position 'bottom)
     dash
     osx
     (gtags :variables gtags-enable-by-default t)
     ;; (colors :variables
     ;;         colors-enable-nyan-cat-progress-bar t)
     ;; (chinese :variables
     ;;          chinese-enable-youdao-dict nil)
     (spell-checking :variables
                     spell-checking-enable-by-default t
                     enable-flyspell-auto-completion nil)
     ;; (mu4e :variables
     ;;       mu4e-use-maildirs-extension nil
     ;;       mu4e-enable-async-operations t
     ;;       mu4e-enable-mode-line t
     ;;       mu4e-enable-notifications t)
     templates
     (auto-completion :variables
                      auto-completion-tab-key-behavior 'complete
                      auto-completion-return-key-behavior 'complete
                      auto-completion-complete-with-key-sequence-delay 0.1
                      auto-completion-idle-delay 0.2
                      auto-completion-enable-snippets-in-popup t
                      auto-completion-enable-help-tooltip t
                      auto-completion-enable-sort-by-usage t
                      spacemacs-default-company-backends '(company-dabbrev-code company-gtags company-keywords company-files company-dabbrev company-files company-semantic company-abbrev company-keywords company-bbdb company-capf company-ispell))
     (syntax-checking :variables syntax-checking-enable-by-default t)
     (wakatime :variables wakatime-api-key "06fb08d0-68a4-4b39-bbb0-d34d325dc046"
               ;; use the actual wakatime path
               wakatime-cli-path "/usr/local/bin/wakatime")
     ;; bibtex
     (org :variables
          org-enable-bootstrap-support t
          org-enable-github-support t
          org-enable-reveal-js-support t
          org-enable-org-journal-support t
          org-enable-hugo-support t
          org-projectile-file "~/Dropbox/Org/Projects.org")
     yaml
     (javascript :variables javascript-disable-tern-port-files nil)
     ;; rust
     html
     ;; plantuml
     ;; (scala :variables
     ;;        scala-use-unicode-arrows t)
     ;; go
     emacs-lisp
     (haskell :variables
              haskell-completion-backend 'intero
              )
     nixos
     )
   dotspacemacs-additional-packages
   '(nix-sandbox)
   dotspacemacs-frozen-packages
   '()
   dotspacemacs-excluded-packages
   '(evil-escape
     )
   dotspacemacs-install-packages
   'used-only))
(defun dotspacemacs/init ()
  (setq-default
   dotspacemacs-check-for-update nil
   dotspacemacs-elpa-subdirectory nil
   dotspacemacs-editing-style '(hybrid :variables
                                       hybrid-mode-enable-evilified-state t
                                       hybrid-mode-enable-hjkl-bindings nil
                                       hybrid-mode-use-evil-search-module nil
                                       hybrid-mode-default-state 'normal)
   dotspacemacs-verbose-loading nil
   dotspacemacs-startup-banner nil
   dotspacemacs-startup-lists '((recents . 3)(projects . 3))
   dotspacemacs-startup-buffer-responsive nil
   dotspacemacs-scratch-mode 'text-mode
   dotspacemacs-themes '(spacemacs-dark
                         molokai)
   dotspacemacs-colorize-cursor-according-to-state t
   dotspacemacs-default-font '(
                               "Source Code Pro" :size 15
                               ;; "InconsolataForPowerline Nerd Font" :size 14
                               :weight normal
                               :width normal
                               :powerline-scale 1.1)
   dotspacemacs-leader-key "SPC"
   dotspacemacs-emacs-command-key "SPC"
   dotspacemacs-ex-command-key ":"
   dotspacemacs-emacs-leader-key "M-m"
   dotspacemacs-major-mode-leader-key ","
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"
   dotspacemacs-distinguish-gui-tab nil
   dotspacemacs-remap-Y-to-y$ nil
   dotspacemacs-retain-visual-state-on-shift t
   dotspacemacs-visual-line-move-text nil
   dotspacemacs-ex-substitute-global nil
   dotspacemacs-default-layout-name "Bitmain"
   dotspacemacs-display-default-layout t
   dotspacemacs-auto-resume-layouts nil
   dotspacemacs-large-file-size 0.5
   dotspacemacs-auto-save-file-location 'original
   dotspacemacs-max-rollback-slots 5
   dotspacemacs-helm-resize nil
   dotspacemacs-helm-no-header nil
   dotspacemacs-helm-position 'bottom
   dotspacemacs-helm-use-fuzzy 'always
   dotspacemacs-enable-paste-transient-state nil
   dotspacemacs-which-key-delay 0.4
   dotspacemacs-which-key-position 'bottom
   dotspacemacs-loading-progress-bar t
   dotspacemacs-fullscreen-at-startup nil
   dotspacemacs-fullscreen-use-non-native t
   dotspacemacs-maximized-at-startup t
   dotspacemacs-active-transparency 90
   dotspacemacs-inactive-transparency 90
   dotspacemacs-show-transient-state-title t
   dotspacemacs-show-transient-state-color-guide t
   dotspacemacs-mode-line-unicode-symbols t
   dotspacemacs-mode-line-theme 'spacemacs
   dotspacemacs-smooth-scrolling t
   dotspacemacs-line-numbers '(:relative t :disabled-for-modes dired-mode
                                         doc-view-mode markdown-mode org-mode pdf-view-mode
                                         text-mode :size-limit-kb 100)
   dotspacemacs-folding-method 'evil
   dotspacemacs-smartparens-strict-mode nil
   dotspacemacs-smart-closing-parenthesis nil
   dotspacemacs-highlight-delimiters 'all
   dotspacemacs-persistent-server t
   dotspacemacs-search-tools '("pt" "grep")
   dotspacemacs-default-package-repository nil
   dotspacemacs-whitespace-cleanup 'trailing))
(defun dotspacemacs/user-init ()
  (setq exec-path-from-shell-arguments '("-l"))
  "Initialization function for user code.
It is called immediately after `dotspacemacs/init', before layer configuration
executes.
 This function is mostly useful for variables that need to be set
before packages are loaded. If you are unsure, you should try in setting them in
`dotspacemacs/user-config' first.")
(defun dotspacemacs/user-config ()
  ;; Configure flycheck to use Nix
  ;; https://github.com/travisbhartwell/nix-emacs#flycheck
  ;; Requires `nix-sandbox` package added to dotspacemacs-additional-packages
  (setq flycheck-command-wrapper-function
        (lambda (command) (apply 'nix-shell-command (nix-current-sandbox) command)))
  (setq flycheck-executable-find
        (lambda (cmd) (nix-executable-find (nix-current-sandbox) cmd)))

  ;; Configure haskell-mode (haskell-cabal) to use Nix
  (setq haskell-process-wrapper-function
        (lambda (args) (apply 'nix-shell-command (nix-current-sandbox) args)))

  ;; Configure haskell-mode to use cabal new-style builds
  (setq haskell-process-type 'cabal-new-repl)

  ;; We have limit flycheck to haskell because the above wrapper configuration is global (!)
  ;; FIXME: How? Using mode local variables?
  (setq flycheck-global-modes '(haskell-mode))

  (auto-save-visited-mode 1)
  (setq auto-save-visited-interval 1)
  (with-eval-after-load "haskell-mode"
    ;; This changes the evil "O" and "o" keys for haskell-mode to make sure that
    ;; indentation is done correctly. See
    ;; https://github.com/haskell/haskell-mode/issues/1265#issuecomment-252492026.
    (defun haskell-evil-open-above ()
      (interactive)
      (evil-digit-argument-or-evil-beginning-of-line)
      (haskell-indentation-newline-and-indent)
      (evil-previous-line)
      (haskell-indentation-indent-line)
      (evil-append-line nil))

    (defun haskell-evil-open-below ()
      (interactive)
      (evil-append-line nil)
      (haskell-indentation-newline-and-indent))

    (evil-define-key 'normal haskell-mode-map
      "o" 'haskell-evil-open-below
      "O" 'haskell-evil-open-above)
    )

  ;; use local eslint from node_modules before global
  ;; http://emacs.stackexchange.com/questions/21205/flycheck-with-file-relative-eslint-executable
  (defun my/use-eslint-from-node-modules ()
    (let ((eslint-path (if (projectile-project-p)
                           (concat (projectile-project-root) "node_modules/eslint/bin/eslint.js"))))
      (if (file-exists-p eslint-path)
          (progn
            (message eslint-path)
            (setq flycheck-javascript-eslint-executable eslint-path)))))

  (add-hook 'flycheck-mode-hook #'my/use-eslint-from-node-modules)
  (setq js2-include-node-externs t)

  (setq spacemacs-buffer--warnings nil)
  (when (string= system-type "darwin")
    (setq dired-use-ls-dired nil))
  (setq require-final-newline nil)
  (setq undo-tree-auto-save-history t)
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d.undo/undo")))
  ;;Set key jump only one line
  (define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
  (define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)

  (setq exec-path (append exec-path '("/usr/local/bin")))
  (setq exec-path (append exec-path '("/usr/local/sbin")))

  (setq magit-repository-directories '("~/git/"))

  ;;autocomplete
  (global-company-mode t)
  (golden-ratio-mode t)

  (setq ensime-startup-notification nil)
  (setq ensime-startup-snapshot-notification nil)

  ;;mu4e
  ;; give me ISO(ish) format date-time stamps in the header list
  (setq mu4e-headers-date-format "%Y-%m-%d %H:%M")
  (setq mu4e-attachment-dir "~/Downloads/"
        mu4e-maildir "~/Maildir/"
        mu4e-get-mail-command "mbsync -a -q"
        mu4e-update-interval 100
        mu4e-view-show-images  t
        mu4e-view-prefer-html t
        mu4e-sent-messages-behavior 'delete
        message-kill-buffer-on-exit t
        mu4e-headers-auto-update t
        org-mu4e-link-query-in-headers-mode nil
        mu4e-html2text-command "w3m -dump -T text/html"
        )
  ;; (setq send-mail-function 'message-send-mail-with-sendmail)
  (setq vc-follow-symlinks nil)
  ;; (setq sendmail-program "msmtp")
  (setq message-send-mail-function 'smtpmail-send-it
        starttls-use-gnutls t
        user-mail-address "xiongchenyu6@gmail.com"
        smtpmail-starttls-credentials
        '(("smtp.gmail.com" 587 nil nil))
        smtpmail-auth-credentials
        (expand-file-name "~/.authinfo.gpg")
        smtpmail-default-smtp-server "smtp.gmail.com"
        smtpmail-smtp-server "smtp.gmail.com"
        smtpmail-smtp-service 587
        smtpmail-debug-info t)

  (with-eval-after-load 'mu4e-alert
    (mu4e-alert-set-default-style 'notifier))
  ;; tell msmtp to choose the SMTP server according to the from field in the outgoing email
  (setq message-sendmail-extra-arguments '("--read-envelope-from"))
  (setq message-sendmail-f-is-evil 't)
  ;; convert org mode to HTML automatically
  (setq org-mu4e-convert-to-html t)
  (add-hook 'mu4e-compose-mode-hook 'flyspell-mode)
  (require 'gnus-dired)
  (defun gnus-dired-mail-buffers ()
    "Return a list of active message buffers."
    (let (buffers)
      (save-current-buffer
        (dolist (buffer (buffer-list t))
          (set-buffer buffer)
          (when (and (derived-mode-p 'message-mode)
                     (null message-sent-message-via))
            (push (buffer-name buffer) buffers))))
      (nreverse buffers)))
  (setq gnus-dired-mail-mode 'mu4e-user-agent)
  (add-hook 'dired-mode-hook 'turn-on-gnus-dired-mode)

  ;; gpg
  (setq epg-gpg-program "gpg2")
  (add-hook 'mu4e-compose-mode-hook 'org-mu4e-compose-org-mode)
  (add-hook 'mu4e-view-mode-hook 'epa-mail-mode)

  ;; Turn off js2 mode errors & warnings (we lean on eslint/standard)
  (setq js2-mode-show-parse-errors nil)
  (setq js2-mode-show-strict-warnings nil)

  ;;parabox
  (setq paradox-github-token '3db959a368a082f4290d0c81313e46418d29f199)

  (setq org-journal-dir "~/Dropbox/Org/journal/")
  (setq org-directory "~/Dropbox/Org"
        org-agenda-files (list org-directory)
        org-agenda-diary-file (concat org-directory "/diary.org")
        org-default-notes-file (concat org-directory "/refile.org"))
  ;; Set to the name of the file where new notes will be stored
  (setq org-mobile-inbox-for-pull (concat org-directory "/refile.org"))
  ;; Set to <your Dropbox root directory>/MobileOrg.
  (setq org-mobile-directory "~/Dropbox/Apps/MobileOrg")
  (setq org-latex-compiler "latexmk -pdf %f")
  (setq org-ref-default-bibliography '("~/Dropbox/Org/Papers/references.bib")
        org-ref-pdf-directory "~/Dropbox/Org/Papers/"
        org-ref-bibliography-notes "~/Dropbox/Org/Papers/notes.org")
  (with-eval-after-load 'ox-latex
    (add-to-list 'org-latex-classes
                 '("koma-article"
                   "\\documentclass{scrartcl}"
                   ("\\section{%s}" . "\\section*{%s}")
                   ("\\subsection{%s}" . "\\subsection*{%s}")
                   ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                   ("\\paragraph{%s}" . "\\paragraph*{%s}")
                   ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))))
  (setq org-publish-project-alist
        '(("orgfiles"
           :base-directory "~/Dropbox/Org/"
           :exclude "~/Dropbox/Org/journal"
           :base-extension "org"
           :publishing-directory "~/html/"
           :publishing-function org-twbs-publish-to-html
           :with-sub-superscript nil
           :recursive t
           :timestamp t
           :exclude-tags "noexport"
           :auto-sitemap t                ; Generate sitemap.org automagically...
           :sitemap-filename "index.org"  ; ... call it sitemap.org (it's the default)...
           :sitemap-title "Freeman's notebook"
           :sitemap "index.html"
           :author "Freeman"
           :email "xiongchenyu6@gamil.com"
           :time-stamp-file t
           :makeindex t
           :with-toc t
           :with-timestamps t
           :html-link-home "index.html")
          ("blog-static"
           :base-directory "~/Dropbox/Org"
           :exclude "~/Dropbox/Org/journal"
           :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
           :publishing-directory "~/html/"
           :recursive t
           :publishing-function org-publish-attachment
           )
          ("website" :components ("orgfiles" "blog-static"))))

  (setq indent-guide-global-mode t)
  (setq org-export-date-timestamp-format "%Y-%m-%d")
  (setq org-twbs-postamble 't)
  (setq org-twbs-postamble-format
        '(("en" "<div id='disqus_thread'>
            </div>
            <script type='text/javascript'>
                var disqus_shortname = 'blogfreeman';
                (function() {
                    var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
                    dsq.src = 'https://' + disqus_shortname + '.disqus.com/embed.js';
                    (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
                })();
            </script>
            <p class='author'>
              Author: %a (%e)
            </p>
            <p>Exported At %T. Created by %c </p>
            <a href='#' class='back-to-top' id='fixed-back-to-top' style='display: inline;'></a>"
           )))

  ;; Tags with fast selection keys
  (setq org-tag-alist
        '((:startgroup)
          ("@office" . ?o)
          ("@home" . ?H)
          (:endgroup)
          ("crypt" . ?E)
          ("NOTE" . ?n)
          ("CANCELLED" . ?c)
          ("FLAGGED" . ??)))

  ;; Capture templates for: TODO tasks, Notes, appointments, phone calls, meetings, and org-protocol
  (setq org-capture-templates
        '(("t" "todo"
           entry
           (file "~/Dropbox/Org/refile.org")
           "* TODO %?\n%U\n%a\n"
           :empty-lines 1
           :clock-in t
           :clock-resume t)
          ("l" "link-note"
           entry
           (file "~/Dropbox/Org/refile.org")
           "* %? :NOTE:\n%U\n%a\n"
           :empty-lines 1)
          ("n" "note"
           entry
           (file "~/Dropbox/Org/refile.org")
           "* %? :NOTE:\n%U\n%c\n"
           :prepend t
           :kill-buffer t
           :empty-lines 1)
          ("s" "Code Snippet"
           entry
           (file org-agenda-file-code-snippet)
           "* %?\t%^g\n#+BEGIN_SRC %^{language}\n\n#+END_SRC")
          ("h" "Habit"
           entry
           (file "~/Dropbox/Org/refile.org")
           "* TODO %?\n%U\n%a\nSCHEDULED: %(format-time-string \"%<<%Y-%m-%d %a .+1d/3d>>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: TODO\n:END:\n"
           :empty-lines 1)))

  (setq org-babel-python-command "python3")
  (setq python-shell-interpreter "python3")
  (setq org-plantuml-jar-path "~/Dropbox/plantuml.jar")
  (with-eval-after-load 'org
    (setq org-confirm-babel-evaluate nil)
    (org-babel-do-load-languages
     'org-babel-load-languages
     '((js . t)
       (emacs-lisp . t)
       (ditaa . t)
       (python . t)
       (plantuml . t)
       (gnuplot . t)
       (haskell . t)
       (shell . t)
       (dot . t)
       ))
    (add-to-list 'org-src-lang-modes (quote ("plantuml" . fundamental)))
    )
  (setq org-ditaa-jar-path "/usr/local/Cellar/ditaa/0.11.0/libexec/ditaa-0.11.0-standalone.jar")
  (setq create-lockfiles nil)
  ;; nice face
  (custom-set-faces
   '(company-tooltip-common
     ((t (:inherit company-tooltip :weight bold :underline nil))))
   '(company-tooltip-common-selection
     ((t (:inherit company-tooltip-selection :weight bold :underline nil)))))
  )
(defun dotspacemacs/emacs-custom-settings ()
  "Emacs custom settings.
This is an auto-generated function, do not modify its content directly, use
Emacs customize menu instead.
This function is called at the very end of Spacemacs initialization."
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(yatemplate yasnippet-snippets yaml-mode xterm-color ws-butler writeroom-mode visual-fill-column winum wgrep web-mode web-beautify wakatime-mode volatile-highlights vi-tilde-fringe uuidgen toc-org tagedit symon string-inflection spaceline-all-the-icons spaceline powerline smex smeargle slim-mode shell-pop scss-mode sass-mode reveal-in-osx-finder restart-emacs request rainbow-delimiters pug-mode prettier-js popwin persp-mode password-generator paradox spinner ox-twbs ox-reveal ox-hugo ox-gfm overseer osx-trash osx-dictionary orgit org-projectile org-category-capture org-present org-pomodoro alert log4e gntp org-mime org-journal org-download org-bullets org-brain open-junk-file ob-restclient ob-http nix-sandbox nix-mode neotree nameless multi-term move-text molokai-theme magithub markdown-mode ghub+ apiwrap magit-svn magit-gitflow magit-gh-pulls macrostep lorem-ipsum livid-mode skewer-mode link-hint launchctl json-navigator hierarchy js2-refactor multiple-cursors js2-mode js-doc ivy-yasnippet ivy-xref ivy-purpose window-purpose imenu-list ivy-hydra intero indent-guide impatient-mode simple-httpd hungry-delete htmlize hlint-refactor hl-todo hindent highlight-parentheses highlight-numbers parent-mode highlight-indentation helm-make haskell-snippets haml-mode google-translate golden-ratio gnuplot gitignore-templates gitignore-mode github-search github-clone gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link git-gutter-fringe+ git-gutter-fringe fringe-helper git-gutter+ git-gutter gist gh marshal logito pcache ht ggtags fuzzy flyspell-correct-ivy flyspell-correct flycheck-pos-tip flycheck-haskell haskell-mode flycheck flx-ido flx fill-column-indicator fancy-battery eyebrowse expand-region evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-surround evil-org evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-magit magit git-commit ghub treepy graphql with-editor evil-lisp-state evil-lion evil-indent-plus evil-iedit-state iedit evil-goggles evil-exchange evil-ediff evil-cleverparens smartparens paredit evil-args evil-anzu anzu eval-sexp-fu highlight eshell-z eshell-prompt-extras esh-help emmet-mode elisp-slime-nav editorconfig dumb-jump doom-modeline eldoc-eval shrink-path all-the-icons memoize dockerfile-mode docker json-mode tablist magit-popup docker-tramp json-snatcher json-reformat diff-hl dash-at-point counsel-projectile projectile pkg-info epl counsel-gtags counsel-dash helm-dash helm helm-core counsel-css counsel swiper ivy company-web web-completion-data company-tern dash-functional tern company-statistics company-restclient restclient know-your-http-well company-quickhelp pos-tip company-nixos-options nixos-options company-cabal company column-enforce-mode cmm-mode clean-aindent-mode centered-cursor-mode browse-at-remote f dash s auto-yasnippet yasnippet auto-highlight-symbol auto-dictionary auto-compile packed aggressive-indent ace-window ace-link avy ac-ispell auto-complete popup which-key use-package pcre2el org-plus-contrib hydra font-lock+ evil goto-chg undo-tree dotenv-mode diminish bind-map bind-key async)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
)