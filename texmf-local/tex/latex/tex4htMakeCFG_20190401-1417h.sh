#!/bin/sh

if [ $# -eq 0 ]
then
  echo "usage: ${0##*/} <handoutName>"
  exit 1
fi

echo "\\Preamble{html}"       > $1.cfg
printf '\\begin{document}' >> $1.cfg
echo "\HCode{         " >> $1.cfg
printf "<meta name = \042Author\042      content = \042Christopher D. Carroll\042> \Hnewline \n" >>$1.cfg
printf "<meta name = \042Description\042 content = \042" >>$1.cfg
(cat $1.title | tr -d '\012') >> $1.cfg
printf "\042> \Hnewline \n" >>$1.cfg
printf "<title>"  >> $1.cfg 
(cat $1.title | tr -d '\012') >> $1.cfg
printf "</title> \Hnewline" >> $1.cfg
echo "}" >> $1.cfg
read -r -d '' CenterTabsAndFigs << 'EOF'
\ConfigureEnv{figure}
   {\HCode{<hr class="figure"><center class="figure"\Hnewline}
       \bgroup \Configure{float}{\ShowPar}{}{}%
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


