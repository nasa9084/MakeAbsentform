#!/bin/sh
today=$(date +%Y年%m月%d日)

while getopts o:n:i:d:S:D:C:G:r:a:s:t:h OPT
do
    case $OPT in
        o) fname=$OPTARG ;;
        n) name=$OPTARG ;;
        i) id=$OPTARG ;;
        d) date=$OPTARG ;;
        S) section=$OPTARG ;;
        D) department=$OPTARG ;;
        C) cource=$OPTARG ;;
        G) grade=$OPTARG ;;
        r) reason=$OPTARG ;;
        a) absentdate=$OPTARG ;;
        s) subject=$OPTARG ;;
        t) teacher=$OPTARG ;;
        h) cat<<EOF
USAGE: sh ./MakeAbsentForm.sh [OPTION ARG]...
e.g.) sh ./MakeAbsentForm.sh -o Absentform.pdf

次のオプションが使用できます。引数にはスペースを含まないでください。
オプションを指定した場合、その項目は聞かれず、指定しなかった項目はあとから質問されます。
(出力ファイル名のみ指定無しでデフォルト出力)

-o FILENAME   出力ファイル名を指定。拡張子pdfまで記入してください。
-n NAME       名前
-i ID         学生番号
-d DATE       提出日
-S SECTION    学部
-D DEPARTMENT 学科
-C COURCE     コース
-G GRADE      学年
-r REASON     欠席理由
-a ABSENTDATE 欠席日
-s SUBJECT    科目名
-t TEACHER    教員名
-h            このヘルプを表示します。
EOF
           exit 0 ;;
    esac
done
echo "$fname"

if [ "$name" = '' ];then
    echo "名前[default:名無しの権兵衛]？"
    read name
    if [ "$name" = '' ];then
        name='名無しの権兵衛'
    fi
fi
if [ "$id" = '' ];then
    echo "学生番号[default:00000000]？"
    read id
    if [ "$id" = '' ];then
        id='00000000'
    fi
fi
if [ "$date" = '' ];then
    echo "提出日[default:" $today "]？"
    read date
    if [ "$date" = '' ];then
        date=$today
    fi
fi
if [ "$section" = '' ];then
    echo "学部[default:工]？"
    read section
    if [ "$section" = '' ];then
        section='工'
    fi
fi
if [ "$department" = '' ];then
    echo "学科[default:情報エレクトロニクス]？"
    read department
    if [ "$department" = '' ];then
        department='情報エレクトロニクス'
    fi
fi
if [ "$cource" = '' ];then
    echo "コース[default:コンピュータサイエンス]？"
    read cource
    if [ "$cource" = '' ];then
        cource='コンピュータサイエンス'
    fi
fi
if [ "$grade" = '' ];then
    echo "学年[default:3]？"
    read grade
    if [ "$grade" = '' ];then
        grade=3
    fi
fi
if [ "$reason" = '' ];then
    echo "理由[default:体調不良]？"
    read reason
    if [ "$reason" = '' ];then
        reason='体調不良'
    fi
fi
if [ "$absentdate" = '' ];then
    echo "欠席日[default:" $today "]？"
    read absentdate
    if [ "$absentdate" = '' ];then
        absentdate=$today
    fi
fi
if [ "$subject" = '' ];then
    echo "科目[default: 算数]？"
    read subject
    if [ "$subject" = '' ];then
        subject='算数'
    fi
fi
if [ "$teacher" = '' ];then
    echo "教員氏名[default: Jack]？"
    read teacher
    if [ "$teacher" = '' ];then
        teacher='Jack'
    fi
fi

cat <<EOF > absentform.tex
\documentclass[a4paper]{jarticle}
\usepackage{absent-form}
\usepackage[top=30truemm, bottom=30truemm, left=25truemm, right=25truemm]{geometry}

\author{$name}
\id{$id}
\date{$date}
\teacher{$teacher}
\subject{$subject}
\section{$section}
\department{$department}
\course{$cource}
\grade{$grade}
\reason{$reason}
\absentdate{$absentdate}
\begin{document}
\absentform
\end{document}
EOF

cat <<EOF > absent-form.sty
\def\absentform{
\setcounter{page}{0}
\pagestyle{empty}
\null
\begin{center}
 {\huge {\sc 欠席届}}\\\\
\end{center}
\vskip 1cm
\begin{flushright}
 \@date\\\\
\end{flushright}
\vskip 1cm
\begin{flushleft}
 {\large \@teacher 先生\\\\
 \vskip 1cm
 科目名: \@subject\\\\
 \vskip1cm
 \@section 学部 \@department 学科 \@course コース \@grade 年\\\\
 学生番号: \@id\\\\
 氏名: \@author\\\\}
\end{flushleft}
\begin{center}
 {\large 下記の理由により欠席しましたので、お届けします。\\\\
 \vskip 2cm
 記\\\\}
\end{center}
\vskip 2cm
\begin{flushleft}
 欠席理由: \@reason\\\\
 \vskip 1cm
 欠席日: \@absentdate\\\\
\end{flushleft}
\vfil\newpage}

\def\teacher#1{\gdef\@teacher{#1}}
\def\subject#1{\gdef\@subject{#1}}
\def\section#1{\gdef\@section{#1}}
\def\department#1{\gdef\@department{#1}}
\def\course#1{\gdef\@course{#1}}
\def\grade#1{\gdef\@grade{#1}}
\def\id#1{\gdef\@id{#1}}
\def\reason#1{\gdef\@reason{#1}}
\def\absentdate#1{\gdef\@absentdate{#1}}
EOF

if [ "$fname" = '' ];then
    fname=absentform_`date +%Y_%m_%d`_"$subject".pdf
fi

platex -interaction=nonstopmode absentform.tex
dvipdfmx -o absentform.pdf absentform.dvi
mv absentform.pdf "$fname"

for i in absent-form.sty absentform.aux absentform.dvi absentform.log absentform.tex
do
    rm $i
done
