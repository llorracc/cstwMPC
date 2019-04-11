#!/bin/sh
# 20190210: Spent much of the day trying to figure out how to use MathML and/or MathJax
# for rendering math.  This script is the result.  
# Conclusion: Technology is not there yet
# Specifically, even after lots of tweaks and configuration,
# it seems that superscripts and subscripts defined in macros do not work properly
# and there is no good fix

# PS. There is a development version (not the "stable" public release) of make4ht that will
# render everything as svg images, obviating the need for the browser to have MathJax installed
# Eventually this should become the default, but not until the revised version of make4ht
# gets incorporated by default into TeXLive. Google "pre-compiled mathjax output using mathjax node"

if [ $# -eq 0 ]; then
  echo "usage: ${0##*/} <handoutName>"
  exit 1
fi

# This heredoc produces an exact copy of the cfg file from https://www.12000.org/my_notes/faq/LATEX/htse54.htm
cat << EOF > $1.cfg
\Preamble{mathml}
\Configure{VERSION}{}
  \Configure{DOCTYPE}{\HCode{<!DOCTYPE html>\Hnewline}} 
  \Configure{HTML}{\HCode{<html>\Hnewline}}{\HCode{\Hnewline</html>}} 
  \Configure{@HEAD}{} 
  \Configure{@HEAD}{\HCode{<meta charset="UTF-8" />\Hnewline}} 
  \Configure{@HEAD}{\HCode{<meta name="generator" content="TeX4ht 
  (http://www.cse.ohio-state.edu/\string~gurari/TeX4ht/)" />\Hnewline}} 
  \Configure{@HEAD}{\HCode{<link 
           rel="stylesheet" type="text/css" 
           href="\expandafter\csname aa:CssFile\endcsname" />\Hnewline}} 

  \Configure{@HEAD}{\HCode{% 
     <script type="text/x-mathjax-config"> 
       MathJax.Hub.Config({ 
         extensions: ["tex2jax.js"], 
         jax: ["input/TeX", "output/HTML-CSS"], 
         tex2jax: { 
           \unexpanded{inlineMath: [ ['$','$'], ["\\\\(","\\\\)"] ],} 
           \unexpanded{displayMath: [ ['\$\$','\$\$'], ["\\\\[","\\\\]"] ],} 
           processEscapes: true 
         }, 
         "HTML-CSS": { availableFonts: ["TeX"] } 
       }); 
     </script> 
  }} 

  \Configure{@HEAD}{\HCode{<script type="text/javascript" 
    src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"> 
    </script>}}

  \Configure{@HEAD}{\HCode{<style type="text/css"> 
    .MathJax_MathML {text-indent: 0;} 
  </style>}} 

EOF

printf '\\begin{document} \n' >> $1.cfg
echo "\HCode{         " >> $1.cfg
printf "<meta name = \042Author\042      content = \042Christopher D. Carroll\042> \Hnewline \n" >>$1.cfg
printf "<meta name = \042Description\042 content = \042" >>$1.cfg
[[ -e $1.title ]] && (cat $1.title | tr -d '\012') >> $1.cfg
[[ -e $1.title ]] && printf "\042> \Hnewline \n" >>$1.cfg
[[ -e $1.title ]] && printf "<title>"  >> $1.cfg 
[[ -e $1.title ]] && (cat $1.title | tr -d '\012') >> $1.cfg
[[ -e $1.title ]] && printf "</title> \Hnewline" >> $1.cfg
echo "}" >> $1.cfg
read -r -d '' CenterTabsAndFigs << 'EOF'
\ConfigureEnv{figure}
   {\HCode{<hr class="figure"><center class="figure"\Hnewline}
       \\bgroup \Configure{float}{\ShowPar}{}{}%
   }
   {\egroup \HCode{</center><hr class="endfigure"}\ShowPar
\par}
   {}{}
\ConfigureEnv{table}
   {\EndP \HCode{<center class="table">}}
   {\EndP \HCode{</center>}\par\ShowPar}
   {}{}
EOF
echo "$CenterTabsAndFigs" >> $1.cfg

printf '\\EndPreamble' >> $1.cfg
echo '' >> $1.cfg

