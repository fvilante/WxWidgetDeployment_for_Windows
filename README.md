objetivo: Registrar anotacoes de como fiz para instalar o wxwidgets a partir do github direto do source
::

====
COMO INSTALAR O WXWIDGET DO GITHUB NO WINDOWS USANDO MINGW
====


--------------------------------
VERSOES DO BUILDING
--------------------------------
versao do windows:
     * windows 7 ultimate / versao 6.1 (build 7601: Service Pack 1) ano 2009. (copia nao licenciada)
versao do mingw-gcc e g++:
     * 5.3.0 (precisei usar uma versao antes da ultima que era a 6.3, pois nao estava compilando corretamente)
versao do wxwidgets:
     * usei a tag v3.0.2 (98% dos samples funcionaram)
     * aparentemente a tag v3.0.4 também compila

---------------------------------------------------------
como baixar o wxWidgets do github
---------------------------------------------------------

NOTA: Primento, antes de tudo, voce precisa instalar o "git" no seu windows na sua linha de comando (este passo nao sera aprentado aqui, pesquise no google como fazr)
NOTA2: Voce tambem abaixar o wxWidgets direto do site deles, porém eventualmente voce pode enfrentar algum problema na hora de compilar como aconteceu no meu caso se vc pegar uma versao que contem algum problema de compilacao, mas pode valer a pena ariscar. Se voce optar por esta opcao pode passar para o proximo passo.

1. Va ao diretorio raiz em  "c:\" por exemplo.
2. Digite: git clone https://github.com/wxWidgets/wxWidgets.git
3. Aguarde enquanto o repositorio git do wxwidgets eh baixado para seu computador (cerca de 10 minutos)
4. Digite o seguinte comando para resgatar do repositorio uma versao especifica do fonte:
     cd $env:wxwin
     git reset --hard v3.0.2    
     git clean -x -d -f

Pronto, neste ponto vc possui um spapshot da versao 3.0.2 do codigo fonte.
NOTA: Caso voce queira ver outras versoes disponiveis do wxwidgets digite: "git tag".  Em seguida digite a tecla page-down page-up para navegar nas tags, e quando tiver concluido digite a tecla "q". As versoes recomendadas sao aquelas tags que comecam com a letra "v", exemplo "v3.0.2".
NOTA: Voce pode tentar executar estes passos com versoes mais recentes e ver se dá certo, corre o risco de dar. e entao voce tera uma versao mais atualizada do wxWidgets.

---------------------------------------------------------
como instalar o gcc e g++ do MINGW
---------------------------------------------------------

Parece que o wxWidgets esta dando conflito na hora de compilar com a ultima versao do gcc disponivel no MINGW hoje que eh a 6.3. Portanto eu baixei uma versao do gcc para 5.3.0 e resolveu. Importante também vc se certificar que todas as outas livrarias do gcc e g++ do mingw estejam instaladas, ou seja, uma instalacao completa, porém apenas a versao do gcc eh uma abaixo.

Tem varias formas de fazer isto, a forma que eu usei foi esta aqui:
1. Baixe o gerenciador de pacotes do mingw
     * Va em: https://sourceforge.net/projects/mingw/files/MinGW/Base/
         * click num botao verde escrito: "Dowload latest version mingw-get-setup.exe"
2. Abra a versao windows dele (pesquise na barra do windows por: "mingw instalation manager"), e depois de abrir a janela do aplicativo, havera uma lista do lado esquerdo da janela, escolha a parte referente a MINGW instale tudo. (trabalho meio manual de ir clicando um por um leva uns 5 minutos)
3. Va para o powershell do windows (que eh um command.exe melhorado) e digite:
     mingw-get.exe update
    mingw-get.exe install "gcc<6.0." "gcc-g++<6.0."
    mingw-get.exe upgrade --recursive "gcc<6.0." "gcc-g++<6.0."
    
     Nota: com isto voce tera uma versao do gcc e g++ no mingw que sera menor que a versao 6.3 que eh a ultima hoje, no meu caso a versao que foi instalada com estes comandos fom a 5.3.

4. Digite "mingw-gcc --version" no powershell, para saber a versao do gcc que voce tem instalada


---------------------------------------------------------
como compilar o wxWidgets na sua maquina:
---------------------------------------------------------

OBSERVACAO: O Script "Install-WxWidgets_v3.0.4" visa executar os passos abaixo de modo automatico.


1. Voce deve setar a variavel de ambiente WXWIN para conter o diretorio principal onde esta instalado o wxwidgets no seu computador: exemplo WXWIN = c:\wxWidgets

1.5 Prepare o arquivo setup.h fazendo da seguinte forma, digite:
     cp $env:wxwin\include\wx\msw\setup0.h $env:wxwin\include\wx
     mv $env:wxwin\include\wx\setup0.h $env:wxwin\include\wx\setup.h
     NOTE: este comando nada mais faz do que copiar o arquivo "setup0.h" que esta no subdiretorio include\wx\msw, para o diretorio include\wx com o novo nome de "setup.h".

2. Va ao diretorio $WXWIN\build\msw, e digite o seguinte comando de compilacao:
     cd  $env:wxwin\build\msw
     mingw32-make -j4 -f makefile.gcc BUILD=release UNICODE=1 SHARED=0 CXXFLAGS="-std=gnu++11"

     nota: se voce quiser realizar um "make clean", simplesmente acrescente "clean" ao final do comando acima.
     nota2: a compilacao leva cerca de 15 minutos.
     nota3: caso surja algum erro nesta etapa voce pode optar por fechar powershell, abrir uma nova seccao e repetir etapa 2.

3. Para verificar que se a compilacao foi bem sucedida mude para o diretorio $WXWIN\samples\minimal, que contem um exemplo basico de um aplicativo "hello word" feito com o wxwidgets, e tente compila-lo executando o mesmo comando do passo acima, ou seja:
     cd $env:wxwin\samples\minimal
     mingw32-make -j4 -f makefile.gcc BUILD=release UNICODE=1 SHARED=0 CXXFLAGS="-std=gnu++11"
    
     Nota: Caso a compilacao tenha sido bem sucedida, o arquivo .EXE resultante terá sido colocado dentro de um subdiretorio chamado "gcc_mswu", basta executar o arquivo .EXE e um pequeno aplicativo numa janela de windows abrirá, representando que a compilacao esta bem sucedida.
     Nota2: Em caso de erro, experimente rodar o comando acima "mingw32-make ..." mais de uma vez em sequencia, pois parece que as vezes o make roda uma ou duas vezes apenas para setar aguns arquivos, e ai na terceira rodada ele comeca a compilar.
    

==================
ANEXOS
==================

--------------------------------
POWERSHELL BONUS
-------------------------------

     * function compile_wx { mingw32-make -j4 -f makefile.gcc BUILD=release UNICODE=1 SHARED=0 CXXFLAGS="-std=gnu++11"}

     ================================
     Compilar e executar qualquer exemplo
     ================================
     1. Va ao diretorio $WINWX\samples e digite:
             notepad Run-Sample.ps1
     2. Digite o texto abaixo no arquivo e salve.
         function compile_wx { mingw32-make -j4 -f makefile.gcc BUILD=release UNICODE=1 SHARED=0 CXXFLAGS="std=gnu++11"}
         $name = $args[0]
         cd $name
         compile_wx
         cd gcc_mswu
         Invoke-Expression (dir *.exe)
         cd ..\..

     Agora para rodar qualquer exemplo digite (sempre a partir do diretorio $WINWX\samples):
         .\Run-Sample nome_do_sample
         onde: nome_do_sample eh o nome de qualquer subdiretorio da pasta sample