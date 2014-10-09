<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><head><title>EmacsWiki: layout-restore.el</title><link rel="alternate" type="application/wiki" title="Edit this page" href="http://www.emacswiki.org/emacs-en?action=edit;id=layout-restore.el" />
<link type="text/css" rel="stylesheet" href="http://netdna.bootstrapcdn.com/twitter-bootstrap/2.3.0/css/bootstrap-combined.min.css" />
<link type="text/css" rel="stylesheet" href="/css/bootstrap.css" />
<meta name="robots" content="INDEX,FOLLOW" /><link rel="alternate" type="application/rss+xml" title="EmacsWiki" href="http://www.emacswiki.org/emacs-en?action=rss" /><link rel="alternate" type="application/rss+xml" title="EmacsWiki: layout-restore.el" href="http://www.emacswiki.org/emacs-en?action=rss;rcidonly=layout-restore.el" />
<link rel="alternate" type="application/rss+xml"
      title="Emacs Wiki with page content"
      href="http://www.emacswiki.org/emacs/full.rss" />
<link rel="alternate" type="application/rss+xml"
      title="Emacs Wiki with page content and diff"
      href="http://www.emacswiki.org/emacs/full-diff.rss" />
<link rel="alternate" type="application/rss+xml"
      title="Emacs Wiki including minor differences"
      href="http://www.emacswiki.org/emacs/minor-edits.rss" />
<link rel="alternate" type="application/rss+xml"
      title="Changes for layout-restore.el only"
      href="http://www.emacswiki.org/emacs?action=rss;rcidonly=layout-restore.el" /><meta name="viewport" content="width=device-width" />
<script type="text/javascript" src="/outliner.0.5.0.62-toc.js"></script>
<script type="text/javascript">

  function addOnloadEvent(fnc) {
    if ( typeof window.addEventListener != "undefined" )
      window.addEventListener( "load", fnc, false );
    else if ( typeof window.attachEvent != "undefined" ) {
      window.attachEvent( "onload", fnc );
    }
    else {
      if ( window.onload != null ) {
	var oldOnload = window.onload;
	window.onload = function ( e ) {
	  oldOnload( e );
	  window[fnc]();
	};
      }
      else
	window.onload = fnc;
    }
  }

  var initToc=function() {

    var outline = HTML5Outline(document.body);
    if (outline.sections.length == 1) {
      outline.sections = outline.sections[0].sections;
    }

    if (outline.sections.length > 1
	|| outline.sections.length == 1
           && outline.sections[0].sections.length > 0) {

      var toc = document.getElementById('toc');

      if (!toc) {
	var divs = document.getElementsByTagName('div');
	for (var i = 0; i < divs.length; i++) {
	  if (divs[i].getAttribute('class') == 'toc') {
	    toc = divs[i];
	    break;
	  }
	}
      }

      if (!toc) {
	var h2 = document.getElementsByTagName('h2')[0];
	if (h2) {
	  toc = document.createElement('div');
	  toc.setAttribute('class', 'toc');
	  h2.parentNode.insertBefore(toc, h2);
	}
      }

      if (toc) {
        var html = outline.asHTML(true);
        toc.innerHTML = html;
      }
    }
  }

  addOnloadEvent(initToc);
  </script>

<script src="http://code.jquery.com/jquery-1.9.1.min.js"></script>
<script src="http://netdna.bootstrapcdn.com/twitter-bootstrap/2.3.0/js/bootstrap.min.js"></script>
<script src="http://emacswiki.org/emacs/emacs-bootstrap.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /></head><body class="http://www.emacswiki.org/emacs-en"><div class="header"><span class="gotobar bar"><a class="local" href="http://www.emacswiki.org/emacs-en/SiteMap">SiteMap</a> <a class="local" href="http://www.emacswiki.org/emacs-en/Search">Search</a> <a class="local" href="http://www.emacswiki.org/emacs-en/ElispArea">ElispArea</a> <a class="local" href="http://www.emacswiki.org/emacs-en/HowTo">HowTo</a> <a class="local" href="http://www.emacswiki.org/emacs-en/Glossary">Glossary</a> <a class="local" href="http://www.emacswiki.org/emacs-en/RecentChanges">RecentChanges</a> <a class="local" href="http://www.emacswiki.org/emacs-en/News">News</a> <a class="local" href="http://www.emacswiki.org/emacs-en/Problems">Problems</a> <a class="local" href="http://www.emacswiki.org/emacs-en/Suggestions">Suggestions</a> </span><br /><span class="specialdays">Monaco, National Day</span><h1><a title="Click to search for references to this page" rel="nofollow" href="http://www.emacswiki.org/emacs-en?search=%22layout-restore%5c.el%22">layout-restore.el</a></h1></div><div class="wrapper"><div class="content browse"><p class="download"><a href="download/layout-restore.el">Download</a></p><pre class="code"><span class="linecomment">;;; layout-restore.el</span>
<span class="linecomment">;; --- keep window configuration as layout and restore it simply.</span>

<span class="linecomment">;; Copyleft (C) Vektor</span>

<span class="linecomment">;; Emacs Lisp Archive Entry</span>
<span class="linecomment">;; Filename:      layout-restore.el</span>
<span class="linecomment">;; Version:       0.4</span>
<span class="linecomment">;; Keywords:      convenience window-configuration layout</span>
<span class="linecomment">;; Author:        Vektor (also Veldrin@SMTH)</span>
<span class="linecomment">;; Maintainer:    Vektor</span>
<span class="linecomment">;; Description:   keep window configuration as layout and restore it.</span>
<span class="linecomment">;; Compatibility: Emacs21.3 Emacs-CVS-21.3.50</span>
<span class="linecomment">;; URL:           http://www.emacswiki.org/cgi-bin/wiki/LayoutRestore</span>

(defconst layout-restore-version "<span class="quote">0.4</span>"
  "<span class="quote">LayoutRestore version number. The latest version is available from
http://www.emacswiki.org/cgi-bin/wiki/LayoutRestore</span>")

<span class="linecomment">;; NOTE: Read the commentary below for how to use this package.</span>

<span class="linecomment">;; This program is free software; you can redistribute it and/or</span>
<span class="linecomment">;; modify it under the terms of the GNU General Public License as</span>
<span class="linecomment">;; published by the Free Software Foundation; either version 2, or (at</span>
<span class="linecomment">;; your option) any later version.</span>

<span class="linecomment">;; This program is distributed in the hope that it will be useful, but</span>
<span class="linecomment">;; WITHOUT ANY WARRANTY; without even the implied warranty of</span>
<span class="linecomment">;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU</span>
<span class="linecomment">;; General Public License for more details.</span>

<span class="linecomment">;; You should have received a copy of the GNU General Public License</span>
<span class="linecomment">;; along with GNU Emacs; see the file COPYING.  If not, write to the</span>
<span class="linecomment">;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,</span>
<span class="linecomment">;; Boston, MA 02111-1307, USA.</span>

<span class="linecomment">;;; Commentary:</span>

<span class="linecomment">;;</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; -------------</span>
<span class="linecomment">;; Background:</span>
<span class="linecomment">;; -------------</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; Sometimes I use multi windows to do my job, and when i</span>
<span class="linecomment">;; switch to other buffer and go back, the original layout is</span>
<span class="linecomment">;; gone.  I have to set it up again.</span>
<span class="linecomment">;; I was very annoyed about this so I tried other packages to</span>
<span class="linecomment">;; help me out.  I found `WinnerMode', which always did</span>
<span class="linecomment">;; something I didn't want, and `TaskMode', which seems too</span>
<span class="linecomment">;; powerful to be used simply.  So I wrote this by myself.</span>
<span class="linecomment">;; Actually this package is my first emacs extention package</span>
<span class="linecomment">;; and I don't really know if I have made it well.  But I think</span>
<span class="linecomment">;; this package is already quite useable.</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; -------------</span>
<span class="linecomment">;; Commands:</span>
<span class="linecomment">;; -------------</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; `layout-save-current' save the current window-configuration</span>
<span class="linecomment">;; as layout so that when next time you switch back to this</span>
<span class="linecomment">;; buffer, the layout will be brought back automatically.  You</span>
<span class="linecomment">;; can also manually use `layout-restore' to restore the layout.</span>
<span class="linecomment">;; When you feel a layout is no more needed, switch to the</span>
<span class="linecomment">;; buffer where saved it and use `layout-delete-current' to</span>
<span class="linecomment">;; delete this layout.  These codes are simple and well</span>
<span class="linecomment">;; documented, you can easily hack it by yourself.</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; -------------</span>
<span class="linecomment">;; Set it up:</span>
<span class="linecomment">;; -------------</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; To start using this package, add following lines to your emacs</span>
<span class="linecomment">;; startup file.</span>
<span class="linecomment">;; ---------------------------------------------------------------</span>
<span class="linecomment">;; (require 'layout-restore)</span>
<span class="linecomment">;; ;; save layout key</span>
<span class="linecomment">;; (global-set-key [?\C-c ?l] 'layout-save-current)</span>
<span class="linecomment">;; ;; load layout key</span>
<span class="linecomment">;; (global-set-key [?\C-c ?\C-l ?\C-l] 'layout-restore)</span>
<span class="linecomment">;; ;; cancel(delete) layout key</span>
<span class="linecomment">;; (global-set-key [?\C-c ?\C-l ?\C-c] 'layout-delete-current)</span>
<span class="linecomment">;; ---------------------------------------------------------------</span>
<span class="linecomment">;; Change the keybindings to whatever you like.</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; -----------------</span>
<span class="linecomment">;; Detailed example:</span>
<span class="linecomment">;; -----------------</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; Let's suppose you are working in buffer A and the emacs now</span>
<span class="linecomment">;; looks like:</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; +-------+</span>
<span class="linecomment">;; |   A_  |</span>
<span class="linecomment">;; +---+---+  (layout 1)</span>
<span class="linecomment">;; | B | C |</span>
<span class="linecomment">;; +---+---+</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; Now for some reason, you want to switch to other buffer and</span>
<span class="linecomment">;; do some other thing, these make your emacs looks like:</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; +---+---+</span>
<span class="linecomment">;; |   |   |</span>
<span class="linecomment">;; | D_| E |  (layout 2)</span>
<span class="linecomment">;; |   |   |</span>
<span class="linecomment">;; +---+---+</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; Now you are working in buffer D and want to switch back to</span>
<span class="linecomment">;; buffer A.  Usually you can do this simply by `C-x b RET'.</span>
<span class="linecomment">;; But what about buffer B and buffer C?  They won't be back</span>
<span class="linecomment">;; automatically when you switch to buffer A.  So your emacs</span>
<span class="linecomment">;; looks like below:</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; +---+---+</span>
<span class="linecomment">;; |   |   |</span>
<span class="linecomment">;; | A_| E |</span>
<span class="linecomment">;; |   |   |</span>
<span class="linecomment">;; +---+---+</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; Well, I am sure this is NOT what you want.</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; By using this package, when you are in buffer A of layout 1,</span>
<span class="linecomment">;; press `C-c l' to remember this layout. Then switch to buffer</span>
<span class="linecomment">;; D to your work.  Now when you switch back to buffer A, the</span>
<span class="linecomment">;; buffer B and C will be brought back automatically, and be</span>
<span class="linecomment">;; placed exactly as where they were.</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; If you want, you can alsa remember layout 2 when you are in</span>
<span class="linecomment">;; buffer D.  simply press `C-c l' to remember it, then you can</span>
<span class="linecomment">;; switch between layout 1 and layout 2 easily when you switch</span>
<span class="linecomment">;; between buffer A and D.</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; To unmemorise a layout, simply press `C-c C-l C-c' in the</span>
<span class="linecomment">;; buffer where you press `C-c l' before.</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; -----------</span>
<span class="linecomment">;; Contact me:</span>
<span class="linecomment">;; -----------</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; Any question, or advice, please mail to</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; XYZvektorXYZ@XYZyeahXYZ.net</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; remove all XYZ from above address to get the real one.</span>
<span class="linecomment">;;</span>

<span class="linecomment">;;; Code:</span>

 


(require 'advice)


(defvar layout-configuration-alist nil
  "<span class="quote">This list contains  window configuration to restore for certain
buffer correlated layout. Each element of this list is a list itself,
it consists of 'active buffer of this layout', 'window-configuration
of this layout', '(buffer . buffer-name) cons of this layout'.</span>")

(defvar layout-accept-buffer-by-name t
  "<span class="quote">This variable decide whether we'll accept a different buffer which have
the same name in case we could find the original buffer. Useful when we want
to keep a layout after close one of its buffer and reopen it.</span>")

(defvar layout-verbose t
  "<span class="quote">Print verbose message.</span>")

(defvar layout-restore-old-window-point nil
  "<span class="quote">Restore the window point at the old place where layout recorded it.</span>")

(defvar layout-restore-after-switchbuffer t
  "<span class="quote">If we should restore layout after `switch-buffer'.</span>")

(defvar layout-restore-after-killbuffer t
  "<span class="quote">If we should restore layout after `kill-buffer'.</span>")

(defvar layout-restore-after-otherwindow nil
  "<span class="quote">If we should restore layout after `other-window', which normally invoked
by C-x o.</span>")


(defun layout-save-current ()
  "<span class="quote">Save the current layout, add a list of current layout to
layout-configuration-alist.</span>"
  (interactive)
  (let ((curbuf (current-buffer))
        (curwincfg (current-window-configuration))
        layoutcfg)
    (setq layoutcfg (list curbuf curwincfg))
    (dolist (window (window-list nil 0))
      <span class="linecomment">;; (window-list) maybe contain a minibuffer, append (nil 0) to avoid</span>
      (setq layoutcfg
            (append layoutcfg
                    (list (cons (window-buffer window)
                                (buffer-name (window-buffer window)))))))
    (dolist (locfg layout-configuration-alist)
      (if (eq curbuf (car locfg))
          (setq layout-configuration-alist
                (delq locfg layout-configuration-alist))))
    (setq layout-configuration-alist
          (cons layoutcfg layout-configuration-alist)))
  (if layout-verbose (message "<span class="quote">Current layout saved.</span>")))
  

(defun layout-restore (&optional BUFFER)
  "<span class="quote">Restore the layout related to the buffer BUFFER, if there is such a layout
saved in `layout-configuration-alist', and update the layout if necessary.</span>"
  (interactive)
  (if (not BUFFER) (setq BUFFER (current-buffer)))
  (let (wincfg
        buflist
        (new-point (not layout-restore-old-window-point))
        new-point-list
        buffer-changed-p
        bufname-changed-p
        new-buffer-cons-list
        (restorep t))
    (dolist (locfg layout-configuration-alist)
      (when (eq BUFFER (car locfg))
        (setq wincfg (cadr locfg))
        (setq buflist (cddr locfg))))
    (when wincfg
      (dolist (bufcons buflist)
        (if (buffer-live-p (car bufcons))
            (if (not (string= (buffer-name (car bufcons))
                              (cdr bufcons)))
                
                (setq bufname-changed-p t
                      new-buffer-cons-list
                      (append new-buffer-cons-list
                              (list (cons (car bufcons)
                                          (buffer-name (car bufcons)))))
                      new-point-list (append new-point-list
                                             (list (save-excursion
                                                     (set-buffer (car bufcons))
                                                     (point)))))
              (setq new-buffer-cons-list (append new-buffer-cons-list (list bufcons))
                    new-point-list (append new-point-list
                                           (list (save-excursion
                                                   (set-buffer (car bufcons))
                                                   (point))))))
          (if (not layout-accept-buffer-by-name)
              (setq buffer-changed-p t
                    restorep nil)
            <span class="linecomment">;; accept reopened buffer by name, if any</span>
            (progn
              (setq buffer-changed-p t)
              (let ((rebuf (get-buffer (cdr bufcons))
                           ))
                (if (not rebuf)
                    (setq restorep nil)
                  (setq new-buffer-cons-list
                        (append new-buffer-cons-list
                                (list (cons rebuf (cdr bufcons))))
                        new-point-list
                        (append new-point-list
                                (list (save-excursion
                                        (set-buffer rebuf)
                                        (point)))))))))))
      (when restorep
        (set-window-configuration wincfg)
        (dolist (window (window-list nil 0))
          (set-window-buffer window (caar new-buffer-cons-list))
          (setq new-buffer-cons-list (cdr new-buffer-cons-list))
          (when new-point
            (set-window-point window (car new-point-list))
            (setq new-point-list (cdr new-point-list))))
        (if (or bufname-changed-p buffer-changed-p)
            (layout-save-current))
        (if layout-verbose (message "<span class="quote">Previous saved layout restored.</span>")))
      )))

(defun layout-delete-current (&optional BUFFER)
  "<span class="quote">Delete the layout information from `layout-configuration-alist'
if there is an element list related to BUFFER.</span>"
  (interactive)
  (if (not BUFFER) (setq BUFFER (current-buffer)))
  (dolist (locfg layout-configuration-alist)
    (when (eq BUFFER (car locfg))
      (setq layout-configuration-alist
            (delq locfg layout-configuration-alist))
      (if layout-verbose (message "<span class="quote">Layout about this buffer deleted.</span>")))
    ))

(defun layout-unique-point-in-same-buffer-windows (&optional BUFFER)
  "<span class="quote">Make identical opint in all windows of a same buffer.</span>"
  (if (not BUFFER) (setq BUFFER (current-buffer)))
  (dolist (locfg layout-configuration-alist)
    (when (eq BUFFER (car locfg))
      (save-excursion
        (set-buffer BUFFER)
        (let ((wlist (get-buffer-window-list BUFFER 0)))
          (dolist (window wlist)
            (set-window-point window (point))))))))
        

(defadvice switch-to-buffer (around layout-restore-after-switch-buffer (BUFFER))
  "<span class="quote">Unique window point before `switch-to-buffer', and restore possible layout
after `switch-to-buffer'.</span>"
  (layout-unique-point-in-same-buffer-windows)
  ad-do-it
  (if layout-restore-after-switchbuffer 
      (layout-restore)))

(defadvice kill-buffer (after layout-restore-after-kill-buffer (BUFFER))
  "<span class="quote">Restore possible layout after `kill-buffer' funcall.</span>"
  (if layout-restore-after-killbuffer
      (layout-restore)))

(defadvice other-window (after layout-restore-after-other-window (ARG))
  "<span class="quote">Restore possible layout after `other-window' funcall.</span>"
  (if layout-restore-after-otherwindow
      (layout-restore)))

(ad-activate 'switch-to-buffer)
(ad-activate 'kill-buffer)
(ad-activate 'other-window)


(provide 'layout-restore)

<span class="linecomment">;;; layout-restore.el ends here.</span></span></pre></div><div class="wrapper close"></div></div><div class="footer"><hr /><span class="gotobar bar"><a class="local" href="http://www.emacswiki.org/emacs-en/SiteMap">SiteMap</a> <a class="local" href="http://www.emacswiki.org/emacs-en/Search">Search</a> <a class="local" href="http://www.emacswiki.org/emacs-en/ElispArea">ElispArea</a> <a class="local" href="http://www.emacswiki.org/emacs-en/HowTo">HowTo</a> <a class="local" href="http://www.emacswiki.org/emacs-en/Glossary">Glossary</a> <a class="local" href="http://www.emacswiki.org/emacs-en/RecentChanges">RecentChanges</a> <a class="local" href="http://www.emacswiki.org/emacs-en/News">News</a> <a class="local" href="http://www.emacswiki.org/emacs-en/Problems">Problems</a> <a class="local" href="http://www.emacswiki.org/emacs-en/Suggestions">Suggestions</a> </span><span class="translation bar"><br />  <a class="translation new" rel="nofollow" href="http://www.emacswiki.org/emacs-en?action=translate;id=layout-restore.el;missing=de_en_es_fr_it_ja_ko_pt_ru_se_zh">Add Translation</a></span><span class="edit bar"><br /> <a class="comment local edit" accesskey="c" href="http://www.emacswiki.org/emacs-en/Comments_on_layout-restore.el">Talk</a> <a class="edit" accesskey="e" title="Click to edit this page" rel="nofollow" href="http://www.emacswiki.org/emacs-en?action=edit;id=layout-restore.el">Edit this page</a> <a class="history" rel="nofollow" href="http://www.emacswiki.org/emacs-en?action=history;id=layout-restore.el">View other revisions</a> <a class="admin" rel="nofollow" href="http://www.emacswiki.org/emacs-en?action=admin;id=layout-restore.el">Administration</a></span><span class="time"><br /> Last edited 2005-10-13 17:56 UTC by <a class="author" title="from 217-162-112-104.dclient.hispeed.ch" href="http://www.emacswiki.org/emacs-en/AlexSchroeder">AlexSchroeder</a> <a class="diff" rel="nofollow" href="http://www.emacswiki.org/emacs-en?action=browse;diff=2;id=layout-restore.el">(diff)</a></span><form method="get" action="http://www.emacswiki.org/cgi-bin/emacs-en" enctype="multipart/form-data" accept-charset="utf-8" class="search">
<p><label for="search">Search:</label> <input type="text" name="search"  size="20" accesskey="f" id="search" /> <label for="searchlang">Language:</label> <input type="text" name="lang"  size="10" id="searchlang" /> <input type="submit" name="dosearch" value="Go!" /></p></form><div style="float:right; margin-left:1ex;">
<!-- Creative Commons License -->
<a class="licence" href="http://creativecommons.org/licenses/GPL/2.0/"><img alt="CC-GNU GPL" style="border:none" src="/pics/cc-GPL-a.png" /></a>
<!-- /Creative Commons License -->
</div>

<!--
<rdf:RDF xmlns="http://web.resource.org/cc/"
 xmlns:dc="http://purl.org/dc/elements/1.1/"
 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
<Work rdf:about="">
   <license rdf:resource="http://creativecommons.org/licenses/GPL/2.0/" />
  <dc:type rdf:resource="http://purl.org/dc/dcmitype/Software" />
</Work>

<License rdf:about="http://creativecommons.org/licenses/GPL/2.0/">
   <permits rdf:resource="http://web.resource.org/cc/Reproduction" />
   <permits rdf:resource="http://web.resource.org/cc/Distribution" />
   <requires rdf:resource="http://web.resource.org/cc/Notice" />
   <permits rdf:resource="http://web.resource.org/cc/DerivativeWorks" />
   <requires rdf:resource="http://web.resource.org/cc/ShareAlike" />
   <requires rdf:resource="http://web.resource.org/cc/SourceCode" />
</License>
</rdf:RDF>
-->

<p class="legal">
This work is licensed to you under version 2 of the
<a href="http://www.gnu.org/">GNU</a> <a href="/GPL">General Public License</a>.
Alternatively, you may choose to receive this work under any other
license that grants the right to use, copy, modify, and/or distribute
the work, as long as that license imposes the restriction that
derivative works have to grant the same rights and impose the same
restriction. For example, you may choose to receive this work under
the
<a href="http://www.gnu.org/">GNU</a>
<a href="/FDL">Free Documentation License</a>, the
<a href="http://creativecommons.org/">CreativeCommons</a>
<a href="http://creativecommons.org/licenses/sa/1.0/">ShareAlike</a>
License, the XEmacs manual license, or
<a href="/OLD">similar licenses</a>.
</p>
</div>
</body>
</html>
