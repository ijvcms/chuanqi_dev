-- 用户协议
-- Author: Shine
--

-- 系统公告界面。
local AgreementView = class("AgreementView", function()
	return display.newColorLayer(cc.c4b(0,0,0,100))
end)

local BOTTM_MARGIN = 80
local VIEW_SIZE = cc.size(944, 556)
local INFO_SIZE = cc.size(886, 402)

function AgreementView:ctor(info)
	self.info = info or "<font color='0xFFFFFF' size='22' opacity='255'>《最终用户使用许可协议》<br/>重要须知：<br/>第一、用户在使用软件及相关各项服务之前，请仔细阅读本《游戏最终用户使用许可协议》(下称《协议》)中各项条款。</font><br/> <font color='0xFF0000' size='22' opacity='255'>公司在此特别提醒用户认真阅读本《协议》的全部条款，特别是其中免除或者限制公司责任的条款（该等条款通常有“不负任何责任”、“无义务”等词汇）中的条款和其它限制用户权利的条款（该等条款通常含有“不得”等词汇），这些条款应在中国法律所允许的范围内最大程度地适用且通常用红色字表述。<br/>第二、如用户不同意本《协议》的条款，请不要安装、使用本软件或者相关服务。用户一旦点击“接受”并安装本软件，或者注册、开始使用及/或继续使用本软件或相关服务，即视为用户已经接受本《协议》中全部条款。</font><font color='0xFFFFFF' size='22' opacity='255'><br/>第三、用户有权在使用本软件及相关服务的期间，监督公司及公司的工作人员是否按照公司所公布的标准向用户提供服务，也可以随时向公司提出与公司的产品和服务有关意见和建议。<br/> 1、定义和说明：<br/> 本《协议》中，如无相反说明，以下词语具有如下含义：<br/> 1.1 公司：指广州网络科技有限公司。<br/>1.2 游戏：指公司研发/运营的网络游戏。<br/> 1.3 本软件：指游戏计算机软件，包含客户端内容及程序，并可能包括相关网络服务器、网站（包括但不限于游戏官方网站: www.wewars.com/txsc ）、电子媒体、印刷材料和“联机”或电子文档等。<br/> 1.4 用户：又称“最终用户”，指通过公司提供的合法途径获得游戏软件使用许可而安装、使用游戏软件产品及服务的个人。<br/>2、知识产权声明<br/>2.1 公司依法享有游戏的一切合法权属（包括但不限于知识产权）。本软件的全部著作权及一切其他知识产权，以及与本软件相关的所有信息内容，包括但不限于：文字表述及其组合、图标、图饰、图表、色彩组合、界面设计、版面框架、有关数据、印刷材料、或电子文档等均受中国知识产权相关法律法规和有关的国际条约的保护。<br/>2.2 游戏软件所体现的“公司”、“游戏”、游戏徽标（图形）和/或公司的产品和服务标示均属于公司及其关联公司在中国及/或其他国家/地区的商标或者注册商标。用户未经合法授权不得自行使用。<br/>2.3 公司及其关联公司在涉及游戏软件及相关各项服务中拥有专利权、专利申请权、商标权、著作权及其他知识产权。公司及其关联公司并未因为本《协议》或者因为向用户提供本软件以及相关服务而授予用户任何与本软件相关的知识产权。本《协议》未明确授予用户的权利均由公司及其关联公司保留。<br/>3．隐私政策：<br/>尊重用户个人隐私是公司的一项基本政策，所以，公司不会公开、修改或透露用户的注册资料及保存在公司各项服务中的非公开内容，除非公司在诚信的基础上认为透露这些信息是必要的，包括但不限于以下情形：<br/>3.1遵守有关法律法规规定，包括在国家有关机关查询时，提供用户在公司的网页上发布的信息内容及其发布时间、互联网地址或者域名。</font><br/><font color='0xFF0000' size='22' opacity='255'>3.2保持维护公司的知识产权和其他重要权利。<br/></font><font color='0xFFFFFF' size='22' opacity='255'>3.3在紧急情况下竭力维护用户个人和社会大众的隐私安全。<br/>3.4根据《通行证服务条款》、公司公布的规则、制度或者公司认为必要的其他情况下。<br/>4.责任限制<br/></font><font color='0xFF0000' size='22' opacity='255'>4.1用户承诺自行承担因使用本软件及相关服务所引起的任何风险。除根据特定目的和不违反规定的明确的适当的担保以外，公司不作其他任何类型的担保（不论是明确的或隐含的）。公司不担保：<br/></font><font color='0xFFFFFF' size='22' opacity='255'>4.1.1本软件及公司提供的相关服务符合用户的要求；<br/></font><font color='0xFF0000' size='22' opacity='255'>4.1.2本软件及公司提供的相关服务不受不可抗力、计算机病毒、黑客攻击、系统不稳定、用户所在位置、用户关机、电信部门原因及其他任何网络、技术、通信线路等外界或人为因素的影响；<br/>4.1.3安装、复制、访问网站、充值、运行本软件或以其它方式使用本软件及/或接受公司提供的相关服务与任何其他软件不存在任何冲突；<br/>4.1.4通过公司网站、游戏官方网站及其他相关网络上的链接和标签所指向的第三方的商业信誉及其提供服务的真实性、有效性和合法性。<br/></font><font color='0xFFFFFF' size='22' opacity='255'>5.软件、服务与协议的变更、终止<br/>5.1为了保障公司业务发展，公司拥有变更本软件（包括但不限于升级、更新、增加、减少、演绎，等）及相关服务以及本《协议》内容的权利，也拥有终止本软件/相关服务/本《协议》的权利；如有必要，公司会以公告等形式公布于游戏网站(www.wewars.com/txsc)重要页面上。公司提请用户定期查阅了解有关变更、终止等信息。</font><br/><font color='0xFF0000' size='22' opacity='255'>5.2用户拥有自主权利，单方面随时决定终止使用本软件及相关服务并卸载本软件。如公司对本软件、相关服务或本《协议》的内容作出任何变更，而用户不同意有关变更的内容，用户有权单方面立即停止使用本软件以及相关服务并卸载本软件。如用户在有关内容变更后，仍继续使用本软件和相关服务，即视为用户同意接受有关变更内容。<br/></font><font color='0xFFFFFF' size='22' opacity='255'>6．权利和义务：<br/>6.1在用户同意接受本《协议》全部内容的前提下，公司同意授予用户可撤销的、可变更的、非专有的、不可转让和不可再授权的许可权利。用户可在许可生效的时间内将本软件安装在个人使用的联网计算机上，并以指定的方式运行本软件的一份副本并享受公司提供的服务。公司基于本《协议》授予用户的许可是针对个人使用的许可。如用户有需要在个人使用的范围以外使用本软件及服务或者将本软件与服务用于任何商业用途，则用户应与公司联系并获得公司另行授权。任何未经公司许可的安装、使用、访问、显示、运行等行为均视为违反本协议。<br/>6.2 除非本《协议》另有规定，否则，未经公司书面同意，用户不得实施下列行为（无论是营利的还是非营利的）：<br/>6.2.1复制、翻拷、传播和陈列本软件的程序、使用手册和其它图文音像资料的全部或部分内容。<br/>6.2.2公开展示和播放本产品的全部或部分内容。<br/>6.2.3出租、销售本软件或者利用本软件从事营利行为。<br/>6.2.4修改或遮盖本软件程序、图像、动画、包装和手册等内容上的产品名称、公司标志、版权信息等内容。<br/>6.2.5 其它违反著作权法、计算机软件保护条例和相关法律法规的行为。<br/></font><font color='0xFF0000' size='22' opacity='255'>6.3 用户应通过合法的途径使用本软件和相关服务，不得作出以下侵害公司或第三人利益，扰乱游戏秩序，违反游戏公平性、违反本《协议》或者公司发布的其他规则或者国家有关法律法规规定的行为，包括但不限于： <br/>6.3.1 修改、翻译、注释、整理、汇编、演绎本软件； <br/>6.3.2 反向工程、反向编译或者反汇编本软件，或者采用其他技术手段对本软件进行分析、修改、攻击、衍生； <br/>6.3.3 使用任何外挂程序或游戏修改程序（本《协议》所称“外挂程序”是指独立于游戏软件之外的，能够在游戏运行的同时影响游戏操作的所有程序，包括但不限于模拟键盘鼠标操作、改变操作环境、修改数据等一切类型。如国家有关法律、法规及政府主管部门的规章或规范性文件规定的外挂定义与本《协议》有冲突，则以法律、法规、部门规章或规范性文件规定的为准），对本网络游戏软件进行还原工程、编译、译码或修改，包括但不限于修改本软件所使用的任何专有通讯协议、对动态随机存取内存（RAM）中资料进行修改或锁定； <br/>6.3.4  使用异常的方法登录游戏、使用网络加速器等外挂软件或机器人程式等恶意破坏服务设施、扰乱正常服务秩序的行为； <br/>6.3.5通过异常或者非法方式使用本软件（包括但不限于利用本软件登录游戏私服），恶意破环本软件，扰乱正常的服务秩序或者实施其他不正当行为； <br/>6.3.6制作、传播或使用外挂、封包、加速软件及其它各种作弊程序，或组织、教唆他人使用此类软件程序，或销售此类软件程序而为个人或组织谋取经济利益； <br/>6.3.7使用任何方式或方法，试图攻击提供游戏服务的相关服务器、路由器、交换机以及其他设备，以达到非法获得或修改未经授权的数据资料、影响正常游戏服务，以及其他危害性目的的任何行为；  <br/>6.3.8利用本软件或者线上游戏系统可能存在的技术缺陷或漏洞而以各种形式为自己及他人牟利（包括但不限于复制游戏中的虚拟物品等）或者从事其他不正当行为。 <br/>6.3.9违反国家有关法律法规的规定，利用本软件制作、复制、发布和传播信息。<br/>一旦公司通过内部的监测程序发现或经其他用户举报而发现用户有可能正在从事上述行为，则公司有权作出独立的判断并采取相应的措施，该措施包括但不限于限制用户帐号的登陆、限制用户在游戏中的活动、终止本软件授权、删除与复制有关的物品（包括复制出的虚拟物品和参与复制的虚拟物品）、删除用户的帐号并要求用户赔偿因从事上述行为而给公司造成的损失等。<br/></font><font color='0xFFFFFF' size='22' opacity='255'>6.4公司提供可使用本软件，并运用自己的网络系统通过国际互联网络（Internet）为用户提供服务。同时，用户应自行提供以下的设备和信息：<br/>6.4.1自行配备上网的所需设备， 包括个人电脑、调制解调器或其他必备上网装置。<br/>6.4.2自行负担个人上网所支付的与此服务有关的电话费用、网络费用。<br/>6.4.3基于公司提供服务的重要性，用户同意：<br/>（1）提供详尽、准确的个人资料。<br/>（2）不断更新注册资料，符合及时、详尽、准确的要求。<br/>（3）牢记用户填写的注册资料、历史信息。<br/></font><font color='0xFF0000' size='22' opacity='255'>公司在为用户提供相关客户服务的前提是用户能表明用户是帐号的所有人，这可能需要用户提供相关信息（包括但不限于注册信息、历史密码等）。用户理解，如果用户不能提供准确完整的注册资料及相关历史信息、未及时更新相关注册资料或者相关的证据，将有可能导致公司无法判断用户的身份，从而无法为提供密码找回等相关服务，而公司对此不承担任何责任。如因用户提交的相关信息资料不真实、不准确、不完整、不合法从而导致公司作出错误的判断的，公司有权终止为用户提供服务并追究用户的法律责任。<br/>6.5公司保留通过本软件和相关的服务向用户投放商业性广告的权利。<br/>7.违约责任<br/>7.1用户同意保障和维护公司及其他用户的利益，如因用户违反有关法律、法规或本《协议》项下的任何条款而给公司造成损害，用户同意承担由此造成的损害赔偿责任，该等责任包括但不限于给公司造成的任何直接或间接损失。<br/>7.2 如用户违反本《协议》、公司发布的其他规则或者国家法律法规规定，则公司有权作出独立的判断，立即撤销相关许可，终止为用户提供服务并通过各种合法途径追究用户的法律责任。<br/></font><font color='0xFFFFFF' size='22' opacity='255'>8. 法律适用和争议解决<br/>8.1本《协议》的订立、履行、解释及争议的解决均应适用中华人民共和国法律并排除其他一切冲突法的适用。<br/>8.2如双方就本《协议》内容或其执行发生任何争议，双方应尽量友好协商解决；协商不成时，双方同意交由广州市天河区人民法院管辖并处理。<br/>9.其他规定<br/>9.1 本《协议》构成双方对本《协议》之约定事项及其他有关事宜的完整协议，除本《协议》规定的之外，未赋予本《协议》各方其他权利。<br/>9.2如本《协议》中的任何条款因任何原因被判定为完全或部分无效或不具有执行力的，该无效或不具有执行力的条款将被最接近原条款意图的一项有效并可执行的条款所替代，并且本《协议》的其余条款仍应有效并且有执行力。<br/>9.3公司不行使、未能及时行使或者未充分行使本《协议》或者按照法律规定所享有的权利，不应被视为放弃该权利，也不影响公司在将来行使该权利。<br/>9.4在法律允许的最大范围内，公司保留对本《协议》的最终解释权。</font>"
    self:initialization()
end

function AgreementView:initialization()
	local container = display.newNode()
		:addTo(self)
		:pos((display.width - VIEW_SIZE.width) / 2, (display.height - VIEW_SIZE.height) / 2)

	--标题背景
	local titleBg = display.newSprite()
	local titleBgSize = titleBg:getContentSize()
	titleBg:setPosition(VIEW_SIZE.width / 2, VIEW_SIZE.height - 30)

	--标题
	local title = display.newTTFLabel({text = "用户协议", size = 24, color = TextColor.TEXT_O})
	title:setPosition(titleBgSize.width / 2, titleBgSize.height / 2)
	display.setLabelFilter(title)
	titleBg:addChild(title)

	-- 背景
    -- 描点设置为左下，并居中且拦截鼠标事件。
	local bg = display.newScale9Sprite("common/com_panelPic1.png", 0, 0, VIEW_SIZE,cc.rect(63, 49,1, 1))
	bg:setAnchorPoint(0, 0)
	bg:addChild(titleBg)
	container:addChild(bg)

	local infoBg = display.newScale9Sprite("common/com_viewBgPic2.png", 0, 0, cc.size(INFO_SIZE.width + 20, INFO_SIZE.height + 15))
	infoBg:setAnchorPoint(0, 0)
	infoBg:setPosition((VIEW_SIZE.width - (INFO_SIZE.width + 20)) / 2, BOTTM_MARGIN)
	container:addChild(infoBg)

    -- 公告信息（滚动 + HTML文字）
	local lbl_info = SuperRichText.new(nil, INFO_SIZE.width)
	lbl_info:renderXml(self.info)
	--lbl_info:setPositionY(lbl_info:getContentSize().height)

	local scrollContainer = display.newNode()
	scrollContainer:setContentSize(lbl_info:getContentSize())
	scrollContainer:addChild(lbl_info)

	local scrollView = cc.ScrollView:create(INFO_SIZE)
	scrollView:setPosition((VIEW_SIZE.width - INFO_SIZE.width) / 2, BOTTM_MARGIN)
	scrollView:setDirection(cc.ui.UIScrollView.DIRECTION_VERTICAL)
	scrollView:setContainer(scrollContainer)
	scrollView:setContentOffset(cc.p(0, INFO_SIZE.height - scrollContainer:getContentSize().height))
	container:addChild(scrollView)

    local sizePosX = (VIEW_SIZE.width - 144 * 2) / 3
	--拒绝窗口按钮
	self.rejectBtn = display.newSprite("common/com_labBtnPic1.png")
		:addTo(container)
		:pos(sizePosX + 72, 40)
    self.rejectBtn:setTouchEnabled(true)
    self.rejectBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.rejectBtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.rejectBtn:setScale(1.0)
            os.exit()
        end
        return true
    end)

    local label = display.newTTFLabel({text = "拒绝", size = 20, color = TextColor.BTN_W})
    	:addTo(self.rejectBtn)
    	:pos(56, 21)
    display.setLabelFilter(label)

    --接受窗口按钮
    self.agreeBtn = display.newSprite("common/com_labBtnPic1.png")
		:addTo(container)
		:pos(sizePosX * 2 + 216, 40)
    self.agreeBtn:setTouchEnabled(true)
    self.agreeBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.agreeBtn:setScale(1.2)
            SoundManager:playClickSound()
        elseif event.name == "ended" then
            self.agreeBtn:setScale(1.0)
            cc.UserDefault:getInstance():setStringForKey("FirstLogin", "NO")
            self:close()
        end
        return true
    end)

    label = display.newTTFLabel({text = "接受", size = 20, color = TextColor.BTN_W})
    	:addTo(self.agreeBtn)
    	:pos(56, 21)
    display.setLabelFilter(label)
end

function AgreementView:close()
	self:removeSelf()
end

return AgreementView


