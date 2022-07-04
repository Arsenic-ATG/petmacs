;; -*- lexical-binding: t no-byte-compile: t -*-

(defvar  petmacs-proxy "winhost:1080"
  "Set network proxy.")

(defvar petmacs-socks-proxy "127.0.0.1:1086"
  "Set SOCKS proxy.")

(defvar petmacs-icon (or (display-graphic-p) (daemonp))
  "Display icons or not.")

(defvar  petmacs-font
  "Monego Ligatures"
  ;; "Monego"
  ;; "MonegoLigatures Nerd Font"
  "font")

(defvar petmacs-enable-ligatures t
  "enable ligatures")

(defvar  petmacs-font-size 14.0
  "font size")

(defvar petmacs-lsp-active-modes '(
				                   c-mode
				                   c++-mode
				                   python-mode
				                   java-mode
				                   scala-mode
				                   go-mode
				                   sh-mode
				                   )
  "Primary major modes of the lsp activated layer.")

(defvar petmacs-lsp-client-mode
  'lsp-mode
  ;; 'lsp-bridge-mode
  "lsp-mode or lsp-bridge-mode")

(defvar petmacs-lsp-format-on-save-ignore-modes
  '(c-mode c++-mode python-mode markdown-mode))

(provide 'init-custom)
