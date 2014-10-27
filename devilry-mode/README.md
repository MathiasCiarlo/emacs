#Devilry-mode

##Om
Devilry-mode gjør det enklere å rette obliger. Når du begynner å rette en oblig vises kommer det opp en feedback-template, samt de to forrige tilbakemeldingene til studenten. Dette gjør at man kan gi mye bedre tilbakemeldinger. Deretter vises README.txt og alle javafiler kompileres, ved kompileringsfeil vises disse.
Foreløpig fungerer det kun for java-obliger, med det kan enkelt endres.


##Installering
1) Last ned devilry-mode.el og legg den i en passende mappe, for eksemel "~/.emacs.d/site-lisp/devilry-mode/"

2) Legg følgende til i .emacsfilen din for å sørge for at mappen "devilry-mode.el" ligger i blir loadet når emacs starter.
`
;; Devilry-mode
(add-to-list 'load-path "~/.emacs.d/site-lisp/devilry-mode/")
(require 'devilry-mode)
`
Hvis du får feilmeldig ved oppstart, kontroller at "devilry-mode.el" ligger i riktig mappe.

##Bruk
Skriv `M-x devilry-mode` (alt-x) for å aktivere modusen. Scriptet vil prøve å lese en fil med data fra tidligere økter eller lage den.

##Virkemåte
Devilry-mode bruker en feedbackmappe som inneholder én mappe for hver student. Hver gang man gir en tilbakemeldig, blir denne lagret i riktig mappe under navnet "<oblignummer>.txt".
Programmet bruker en fil "devilry-mode.data" for å lagre data fra forrige økt. Denne inneholder path til feedbackmappen, path til feedback-templaten og hviket oblignummer man er på. Hvis denne ikke finnes blir den opprettet ved oppstart av modusen.