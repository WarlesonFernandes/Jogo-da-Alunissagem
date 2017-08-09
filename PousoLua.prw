#INCLUDE"PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  ณU_PousoLua บ O jogo da alunissagem                          บฑฑ
ฑฑฬออออออออออุอออออออออออสออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAutor     ณWarleson Fernandes                                          บฑฑ
ฑฑบ          ณWarleson@outlook.com                                        บฑฑ
ฑฑบ          ณhttps://www.linkedin.com/in/warleson/                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ Esse programa ้ baseado em um jogo classico escrito para   บฑฑ
ฑฑบ          ณ calculadoras HP-25.Portado para advpl e incluido interface บฑฑ
ฑฑบ          ณ grafica do algoritmo alunissagem, originalmente em         บฑฑ
ฑฑบ          ณ (https://wiki.python.org.br/AprendaProgramar) em python    บฑฑ
ฑฑบ          ณ por luciano ramalho.                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PousoLua
 
Private cMsgInPut,cResp,nQueima,nPosIni,nVelocIni,nVelocFinal

Private oFont3	:= TFont():New('Arial',,-18,.F.)

Private nAltitude	:= 500  //-- Altitude em pes
Private nVelocidade	:= -50  //-- Velocidade em pes/s
Private nCombustivel:= 120 	//-- Quantidade de combustํvel
Private nAceleracao	:= 0  	//-- Aceleracao

Private nAcGravidade:= -5 	//-- Aceleracao gravitacional lunar em pes/s/s
Private nTempo		:= 1  	//-- Tempo entre jogadas em segundos
Private nAlign		:= 0	
		
	Setstyle(5)
		
	DEFINE MSDIALOG oDlg TITLE "Simulacao de Alunissagem" From 0,0 to 500,800 PIXEL

    nMilissegundos := (nTempo*100) 
    oTimer := TTimer():New(nMilissegundos, {||Simula()}, oDlg )

    oPanTit:= TPanel():New(00,00,"",oDlg,,,,,rgb(76,76,76),25,25)
    oPanTit:Align := CONTROL_ALIGN_TOP

		oBtnStart:= TButton():New(05,05,"Player",oPanTit,{||start() },45,15,,,.F.,.T.,.F.,,.F.,,,.F. )   
		oBtnStart:SetCss("QPushButton{Color:rgb(255,255,255);background-color:rgb(0,162,232)}")

		oBtnInfo:= TButton():New(05,55,"Como jogar?",oPanTit,{||GetInst()},45,15,,,.F.,.T.,.F.,,.F.,,,.F. )   
		oBtnInfo:SetCss("QPushButton{Color:rgb(0,0,0);background-color:rgb(220,220,220)}")

    oPanRod:= TPanel():New(00,00,"",oDlg,,,,,rgb(220,220,220),25,25)
    oPanRod:Align := CONTROL_ALIGN_BOTTOM

   	oPx:= TPanel():New(00,00,"",oPanRod,,,,,rgb(220,220,220),5,5)
	oPx:Align := CONTROL_ALIGN_TOP
	                                      
	cAlertas:= ''
	oSayAlertas:= TSay():New(05,05,{||cAlertas},oPanRod,,oFont3,,,,.T.,rgb(237,28,36),,250,20)
	oSayAlertas:Align := CONTROL_ALIGN_RIGHT

    oPanLeft:= TPanel():New(00,00,"",oDlg,,,,,,60,60)
    oPanLeft:Align := CONTROL_ALIGN_LEFT

	    oPanLA:= TPanel():New(00,00,"",oPanLeft,,,,,,38,38)
	    oPanLA:Align := CONTROL_ALIGN_BOTTOM
	    
   	    oPx:= TPanel():New(00,00,"",oPanLA,,,,,,2,2)
	    oPx:Align := CONTROL_ALIGN_BOTTOM

		oSayInput:= TSay():New(0,0,{||'Quantidade de combustivel a queimar'},oPanLA,,,,,,.T.,,,60,16) 
		oSayInput:Align := CONTROL_ALIGN_TOP

		cResp:= '000'
		oResult := TGet():New( 01,01,{|u| if(PCount()>0,cResp:=u,cResp)},oPanLA,045,008,"",{||},,,,,,.T.,,,,,,,.F.,,,cResp)
		oResult:Align := CONTROL_ALIGN_ALLCLIENT		
		oResult:SetContentAlign(nAlign)

		oBtpDn := TButton():New( 000,020,"Avan็ar",oPanLA,{||QueimaComb()}, 50,10,,,.F.,.T.,.F.,,.F.,,,.F. )   
		oBtpDn:Align := CONTROL_ALIGN_BOTTOM

    oPanRight:= TPanel():New(00,00,"",oDlg,,,,,,60,60)
    oPanRight:Align := CONTROL_ALIGN_RIGHT
                           
		o1Spl01:= tSplitter():New( 000,000,oPanRight,100,100,0 )  
		o1Spl01:Align := CONTROL_ALIGN_ALLCLIENT
		o1Spl01:SetOrient(1)
		o1Spl01:SetChildCollapse(.F.)
		o1Spl01:SetOpaqueResize(.T.)
	
			o1PanAplA	:= tPanel():New(000,000,"",o1Spl01,,,,,,15,15)  
			o2PanSplB	:= tPanel():New(000,000,"",o1Spl01,,,,,,85,85) 
			o3PanSplC	:= tPanel():New(000,000,"",o1Spl01,,,,,,85,85) 

		oSay01:= TSay():New(0,0,{||'Altitude em Pes'},o1PanAplA,,,,,,.T.,,,60,08) 
		oSay01:Align := CONTROL_ALIGN_TOP

		oSay01B:= TSay():New(0,0,{||'500'},o1PanAplA,,,,,,.T.,,,60,08) 
		oSay01B:Align := CONTROL_ALIGN_ALLCLIENT


	    oPx:= TPanel():New(00,00,"",o3PanSplC,,,,,,2,2)
	    oPx:Align := CONTROL_ALIGN_BOTTOM
	    
		o1Spl02:= tSplitter():New( 000,000,o3PanSplC,100,100,0 )  
		o1Spl02:Align := CONTROL_ALIGN_ALLCLIENT
		o1Spl02:SetOrient(2)
		o1Spl02:SetChildCollapse(.F.)
		o1Spl02:SetOpaqueResize(.T.)
		
			o4PanSplD	:= tPanel():New(000,000,"",o1Spl02,,,,,,50,50) 
			o5PanSplE	:= tPanel():New(000,000,"",o1Spl02,,,,,,50,50) 

		oSay05:= TSay():New(0,0,{||'Acelera็ใo'},o4PanSplD,,,,,,.T.,,,60,08) 
		oSay05:Align := CONTROL_ALIGN_TOP

		oSay05B:= TSay():New(0,0,{||'0'},o4PanSplD,,,,,,.T.,,,60,08) 
		oSay05B:Align := CONTROL_ALIGN_BOTTOM

	    oPan01:= TPanel():New(00,00,"",o4PanSplD,,,,,,25,25)
	    oPan01:Align := CONTROL_ALIGN_ALLCLIENT
			oSli01 := TSlider():New(0,0,oPan01,{|x|},100,100,"Aceleracao",nil)
			oSli01:Align := CONTROL_ALIGN_ALLCLIENT
			oSli01:SetInterval(1)
			oSli01:SetMarks(1)
			oSli01:SetOrient(1)    
			oSli01:SetRange(-5,115) 
			oSli01:SetStep(1)	
			oSli01:SetValue(nAceleracao)
			oSli01:lReadonly:=.T.
	
		oSay03:= TSay():New(0,0,{||'Velocidade em Pes/S'},o5PanSplE,,,,,,.T.,,,60,16) 
		oSay03:Align := CONTROL_ALIGN_TOP
		
		oSay03B:= TSay():New(0,0,{||'-50'},o5PanSplE,,,,,,.T.,,,60,08) 
		oSay03B:Align := CONTROL_ALIGN_BOTTOM
		
	    oPan02:= TPanel():New(00,00,"",o5PanSplE,,,,,,25,25)
	    oPan02:Align := CONTROL_ALIGN_ALLCLIENT
			oSli02 := TSlider():New(0,0,oPan02,{|x|},100,100,"Velocidade",nil)
			oSli02:Align := CONTROL_ALIGN_ALLCLIENT
			oSli02:SetInterval(0)
			oSli02:SetMarks(1)
			oSli02:SetOrient(1)    
			oSli02:SetRange(-95,65)  
			oSli02:SetStep(1)	
			oSli02:SetValue(nVelocidade)	
			oSli02:lReadonly:=.T.
				
			oSay02:= TSay():New(0,0,{||'Quantidade Combustivel'},o2PanSplB,,,,,,.T.,,,60,08) 
			oSay02:Align := CONTROL_ALIGN_TOP

			oSay02B:= TSay():New(0,0,{||'120'},o2PanSplB,,,,,,.T.,,,60,08) 
			oSay02B:Align := CONTROL_ALIGN_BOTTOM
		    
		    oPan03:= TPanel():New(00,00,"",o2PanSplB,,,,,,25,25)
		    oPan03:Align := CONTROL_ALIGN_ALLCLIENT
				oSli03:= TSlider():New(0,0,oPan03,{|x|},100,100,"Combustivel",nil)
				oSli03:Align := CONTROL_ALIGN_ALLCLIENT
				oSli03:SetInterval(1)
				oSli03:SetMarks(1)
				oSli03:SetOrient(1)    
				oSli03:SetRange(0,120)  
				oSli03:SetStep(1)	
				oSli03:SetValue(nCombustivel)
				oSli03:lReadonly:=.T.

		    oPan04:= TPanel():New(00,00,"",oDlg,,,,,,25,25)
		    oPan04:Align := CONTROL_ALIGN_ALLCLIENT
				oSli04 := TSlider():New(0,0,oPan04,{|x|},100,100,"",nil)
				oSli04:Align := CONTROL_ALIGN_ALLCLIENT
				oSli04:SetInterval(1)
				oSli04:SetMarks(1)
				oSli04:SetOrient(1)    
				oSli04:SetRange(0,930) 
				oSli04:SetStep(0)	
				oSli04:SetValue(nAltitude)
				oSli04:lReadonly:=.T.

				cCss:="QSlider::groove:vertical {"+CRLF
				cCss+="    background: white;"+CRLF
				cCss+="    position: absolute; "+CRLF
				cCss+="    left: 250px; right: 250px;"+CRLF
				cCss+="}"+CRLF
				cCss+=""+CRLF
				cCss+="QSlider::handle:vertical {"+CRLF
				cCss+="    height: 75px;"+CRLF
				cCss+="    background-image: url(rpo:nave1.png);background-repeat: no-repeat;"+CRLF//
				cCss+="    margin: 0 -4px; "+CRLF
				cCss+="}"+CRLF
				cCss+=""+CRLF
				cCss+="QSlider::add-page:vertical {"+CRLF
				cCss+="    background: white;"+CRLF
				cCss+="}"+CRLF
				cCss+=""+CRLF
				cCss+="QSlider::sub-page:vertical {"+CRLF
				cCss+="    background: white;"+CRLF
				cCss+="}"+CRLF

				oSli04:SetCss(cCss)

			oBtpDn:Disable() 
			oBtpDn:SetCss("QPushButton{}")

			oResult:SetContentAlign(nAlign)
			oResult:Refresh()
			oResult:Disable()
		
	ACTIVATE MSDIALOG oDlg CENTER
Return	

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  ณSimula    บAutor  ณWarleson Fernandes                       บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ Evetua chamada para calculos dos dados                     บฑฑ
ฑฑบ          ณ Avalida contato                                            บฑฑ
ฑฑบ          ณ Exibe mensagem final                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static Function Simula()

	If nAltitude > 0	//-- Enquanto nao tocamos o solo
		calcula()			
		oSli01:SetValue(nAceleracao)		
		oSli02:SetValue(nVelocidade)		
		oSli03:SetValue(nCombustivel)

		oSli04:SetValue(nAltitude)		
		oSay01B:SetText(nAltitude)
		oSay01B:CtrlRefresh()
	
		oSay02B:SetText(nCombustivel)
		oSay02B:CtrlRefresh()

		oSay03B:SetText(nVelocidade)
		oSay03B:CtrlRefresh()

		oSay05B:SetText(nAceleracao)
		oSay05B:CtrlRefresh()
		
		Return
	Endif
	
	nAltitude:= 0

	 //----------------------------------------------------
	 // Se o loop acabou, tocamos no solo (nAltitude <= 0)
	 //----------------------------------------------------
	 
	nVelocFinal:= sqrt(nVelocIni*nVelocIni + 2*-nAceleracao*nPosIni)  //-- Calcular vel. final
	 
	oSli01:SetValue(nAceleracao)
	oSli02:SetValue(Round(nVelocFinal*-1,0))//nVelocididade
	oSli03:SetValue(nCombustivel)
	oSli04:SetValue(nAltitude)
	
	oSay01B:SetText(nAltitude)
	oSay01B:CtrlRefresh()
	
	oSay02B:SetText(nCombustivel)
	oSay02B:CtrlRefresh()
	
	oSay03B:SetText(Round(nVelocFinal*-1,0))//nVelocidade
	oSay03B:CtrlRefresh()
	
	oSay05B:SetText(nAceleracao)
	oSay05B:CtrlRefresh()

	cAlertas:='CONTATO! Velocidade final:'+cValtocHar(Round(nVelocFinal*-1,0))
	oSayAlertas:SetText(cAlertas)
	oSayAlertas:CtrlRefresh()

	oBtpDn:Disable() 
	oBtpDn:SetCss("QPushButton{}")

	oResult:SetContentAlign(nAlign)
	oResult:Refresh()
	oResult:Disable()

	 //------------------------------------------------
	 // Avaliar pouso de acordo com a velocidade final
	 //------------------------------------------------
	
	 If nVelocFinal== 0
	     cMsg:= 'Alunissagem perfeita!'
	     MsgInfo(cMsg)
	 Elseif nVelocFinal <= 2
	     cMsg:= 'Alunissagem dentro do padrao.'
	     MsgAlert(cMsg)
	 Elseif  nVelocFinal <= 10
	     cMsg:= 'Alunissagem com avarias leves.'
	     MsgAlert(cMsg)
	 Elseif  nVelocFinal <= 20
	     cMsg:= 'Alunissagem com avarias severas.'
	     MsgAlert(cMsg)
	 Else
	     cMsg:= 'Modulo lunar destruido no impacto.'
	     Alert(cMsg)
	 Endif

    oTimer:DeActivate()  
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  ณcalcula   บAutor  ณWarleson Fernandes                       บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ Obtem a quantidade de combustivel a queimar                บฑฑ
ฑฑบ          ณ e efetua os calculos                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function calcula()

	If nCombustivel > 0	//-- Ainda temos combustivel?
		
		//-------------------------------------------
		// obter quantidade de combustivel a queimar
		//-------------------------------------------

		nQueima:= Val(cResp) //-- Converter resposta em numero
		
		IF nQueima > nCombustivel 	//-- Queimou mais do que tinha?
			nQueima:= nCombustivel	//-- Entao queima o que tem
		Endif
		nCombustivel:= nCombustivel - nQueima   	//-- Subtrai queimado
		nAceleracao:= nAcGravidade + nQueima    	//-- acel:= grav + queima
	else //-- Sem combustivel
		
		oTimer:Activate()

		nAceleracao:= nAcGravidade  //-- aceleracao:= gravidade

		oBtpDn:Disable() 
		oBtpDn:SetCss("QPushButton{}")

		oResult:SetContentAlign(nAlign)
		oResult:Refresh()
		oResult:Disable()
	Endif
	
	nPosIni:= nAltitude	   													//-- Armazenar posicao inicial
	nVelocIni:= nVelocidade													//-- Armazenar velocidade inicial
	nAltitude:= nPosIni + nVelocIni*nTempo + nAceleracao *nTempo*nTempo/2	//-- Calc. nova posicao
	nVelocidade:= nVelocIni + nAceleracao*nTempo               				//-- Calc. nova vel.
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  ณQueimaCombบAutor  ณWarleson Fernandes                       บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ Seta Novos valores e avanca com os calculos                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function QueimaComb()

	Simula()

	cResp:= '000'

	oResult:cText:= cResp
	oResult:SetContentAlign(nAlign)
	oResult:Refresh()
	
	oResult:SetFocus()
	
Return                

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  ณstart     บAutor  ณWarleson Fernandes                       บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ A็ใo do Botao Inicial e Reiniciar o jogo                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function start()

	nAltitude	:= 500  
	nVelocidade	:= -50  
	nCombustivel:= 120 	
	nAceleracao	:= 0  	

 	oSli01:SetValue(nAceleracao)
	oSli02:SetValue(nVelocidade)	
	oSli03:SetValue(nCombustivel)
	oSli04:SetValue(nAltitude)	

	oBtpDn:Enable()
	oBtpDn:SetCss("QPushButton{Color:rgb(255,255,255);background-color:rgb(34,177,76)}")
		
	oResult:cText:= '000'
	oResult:SetContentAlign(nAlign)
	oResult:Refresh()
	oResult:Enable()	

	oSayAlertas:SetText('')
	oSayAlertas:CtrlRefresh()	

	oSay01B:SetText('500')
	oSayAlertas:CtrlRefresh()	
	
	oSay05B:SetText('0')
	oSayAlertas:CtrlRefresh()	

	oSay03B:SetText('-50')     
	oSayAlertas:CtrlRefresh()		

	oSay02B:SetText('120')
	oSayAlertas:CtrlRefresh()		
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบPrograma  ณGetInst   บAutor  ณWarleson Fernandes                       บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDesc.     ณ Informacao de como jogar                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function GetInst()

	cString:= "Seu objetivo ้ desacelerar a nave, queimando combustํvel na dosagem certa ao longo da queda, para tocar o solo lunar com uma velocidade bem pr๓xima de zero. As unidades estใo no sistema ingl๊s, como no original. O mais importante ้ voc๊ saber que cada 5 unidades de combustํvel queimadas anulam a acelera็ใo da gravidade. Se queimar mais do que 5 unidades, voc๊ desacelera; menos do que 5, voc๊ ganha velocidade."+CRLF
	cString+= "Primeiro, pratique seus pousos preocupando-se apenas com a velocidade final.Depois voc๊ pode aumentar a dificuldade, estabelecendo um limite de tempo: por exemplo, o pouso tem que ocorrer em exatos 13 segundos."+CRLF
	cString+= "Uma ๚ltima dica: cuidado para nใo queimar combustํvel cedo demais. Se voc๊ subir, vai acabar caindo de uma altura ainda maior! "+CRLF
	cString+= "Boas alunissagens!"+CRLF

	Msginfo(cString,"Como jogar")
	
Return		