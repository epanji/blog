(require 'ox-twbs)

;; M-x load-file ~/blog/org-export.el

(let ((langs '((emacs-lisp . t)
               (python . t)
               (java . t)
               (php . t))))
  (org-babel-do-load-languages 'org-babel-load-languages langs)
  (setq org-confirm-babel-evaluate nil))

(let* ((k "Figure %d:")
       (v '("id" :default "Gambar %d:"))
       ;; set k and v as needed.
       (pos (cl-position k org-export-dictionary :test #'equal :key #'car))
       (lst (when pos (elt org-export-dictionary pos))))
  (when lst
    (add-to-list 'lst v t)
    (setf (elt org-export-dictionary pos) lst)))

(setq
 org-publish-project-alist
 `(("org-htmls"
    :language "id"
    :base-extension "org"
    :base-directory "~/blog/orgs/"
    :publishing-directory "~/blog/docs/"
    :recursive t
    :publishing-function org-twbs-publish-to-html
    :headline-levels 4
    :head-doctype html5
    :html-head
    ,(mapconcat
      #'identity
      '("<link href=\"assets/bootstrap/css/bootstrap.min.css\" rel=\"stylesheet\"/>"
        "<script src=\"assets/jquery/jquery.min.js\"></script>"
        "<script src=\"assets/bootstrap/js/bootstrap.min.js\"></script>") "\n")
    :creator ,(format "<a href=\"http://www.gnu.org/software/emacs/\">emacs</a> %s (<a href=\"http://orgmode.org\">org</a> mode %s)"
                     emacs-version org-version)
    :auto-preamble t)
   ("org-assets"
    :base-directory "~/blog/orgs/"
    :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
    :publishing-directory "~/blog/docs/"
    :recursive t
    :publishing-function org-publish-attachment)
   ("epanji-blog" :components ("org-htmls" "org-assets"))))

(org-publish-project "epanji-blog" t)
