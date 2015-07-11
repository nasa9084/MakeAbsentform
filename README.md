# MakeAbsentform
Shell Script that makes absent form.
Currently, this script generates Absent form for student at the college of engineering.
欠席届を作成するシェルスクリプトです。
学部・学科に関係なく利用できます。

-hオプションを指定することで、ヘルプを表示します。

>USAGE: sh ./MakeAbsentForm.sh [OPTION ARG]...  
>e.g.) sh ./MakeAbsentForm.sh -o Absentform.pdf  
>  
>次のオプションが使用できます。引数にはスペースを含まないでください。  
>オプションを指定した場合、その項目は聞かれず、指定しなかった項目はあとから質問されます。  
>(出力ファイル名のみ指定無しでデフォルト出力)  
>  
>-o FILENAME   出力ファイル名を指定。拡張子pdfまで記入してください。  
>-n NAME       名前  
>-i ID         学生番号  
>-d DATE       提出日  
>-S SECTION    学部  
>-D DEPARTMENT 学科  
>-C COURCE     コース  
>-G GRADE      学年  
>-r REASON     欠席理由  
>-a ABSENTDATE 欠席日  
>-s SUBJECT    科目名  
>-t TEACHER    教員名  
>-h            このヘルプを表示します。  
