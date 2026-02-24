local PANEL = {}

AccessorFunc( PANEL, 'm_bBorder', 'DrawBorder', FORCE_BOOL )
-- AccessorFunc( PANEL, 'm_sText', 'Text', FORCE_STRING ) // Нет смысла т.к можно более продвинуто сделать в виде PANEL:SetText()

function PANEL:Init()
	self:SetContentAlignment( 5 )

	self:SetDrawBorder( true )

	self:SetTall( 22 )
	self:SetMouseInputEnabled( true )
	self:SetKeyboardInputEnabled( true )
	self:SetText('None', FFLib.Fonts:Get('default', 20, false), FFLib.Theme.WhiteSkeleton)

	self:SetCursor( 'hand' )
end

function PANEL:IsDown()
	return self.Depressed // Ок, депрессия... kid inside...
end

function PANEL:SetText(str, fnt, clr)
	self.Text = str or 'None'
	self.Font = fnt or FFLib.Fonts:Get('default', 20, false)
	self.TextColor = clr or FFLib.Theme.WhiteSkeleton
end

function PANEL:GetText()
	return self.Text
end

function PANEL:GetFont()
	return self.Font
end

function PANEL:GetTextColor()
	return self.TextColor
end

function PANEL:SetImage( img )
	if ( !img ) then
		if ( IsValid( self.m_Image ) ) then
			self.m_Image:Remove()
		end

		return
	end

	if ( !IsValid( self.m_Image ) ) then
		self.m_Image = vgui.Create( 'DImage', self )
	end

	self.m_Image:SetImage( img )
	self.m_Image:SizeToContents()
	self:InvalidateLayout()
end

PANEL.SetIcon = PANEL.SetImage

function PANEL:SetMaterial( mat )
	if ( !mat ) then
		if ( IsValid( self.m_Image ) ) then
			self.m_Image:Remove()
		end

		return
	end

	if ( !IsValid( self.m_Image ) ) then
		self.m_Image = vgui.Create( 'DImage', self )
	end

	self.m_Image:SetMaterial( mat )
	self.m_Image:SizeToContents()
	self:InvalidateLayout()
end

function PANEL:Paint( w, h )
	local skin = self:DrawSkin()
    if !skin or !skin.Button or !skin.Button.Background or !skin.Button.Text then return end
	skin.Button.Background(self, w, h)
	skin.Button.Text(self, w, h)
end

function PANEL:DoClick()
end

function PANEL:OnMousePressed()
	self:DoClick()
	FFLib.DarkRP.Utils:SoundPress(1, 50, 148, .5)
end

function PANEL:UpdateColours( skin )
	if ( !self:IsEnabled() )					then return self:SetTextStyleColor( skin.Colours.Button.Disabled ) end
	if ( self:IsDown() || self.m_bSelected )	then return self:SetTextStyleColor( skin.Colours.Button.Down ) end
	if ( self.Hovered )							then return self:SetTextStyleColor( skin.Colours.Button.Hover ) end

	return self:SetTextStyleColor( skin.Colours.Button.Normal )
end

function PANEL:PerformLayout( w, h )
	if ( IsValid( self.m_Image ) ) then

		local targetSize = math.min( self:GetWide() - 4, self:GetTall() - 4 )

		local zoom = math.min( targetSize / self.m_Image:GetWide(), targetSize / self.m_Image:GetTall(), 1 )
		local newSizeX = math.ceil( self.m_Image:GetWide() * zoom )
		local newSizeY = math.ceil( self.m_Image:GetTall() * zoom )

		self.m_Image:SetWide( newSizeX )
		self.m_Image:SetTall( newSizeY )

		if ( self:GetWide() < self:GetTall() ) then
			self.m_Image:SetPos( 4, ( self:GetTall() - self.m_Image:GetTall() ) * 0.5 )
		else
			self.m_Image:SetPos( 2 + ( targetSize - self.m_Image:GetWide() ) * 0.5, ( self:GetTall() - self.m_Image:GetTall() ) * 0.5 )
		end 

		self:SetTextInset( self.m_Image:GetWide() + 16, 0 )

	end
end

function PANEL:SetConsoleCommand( strName, strArgs )
	self.DoClick = function( self )
		RunConsoleCommand( strName, strArgs )
	end
end

function PANEL:SizeToContents()
	local w, h = self:GetContentSize()
	self:SetSize( w + 8, h + 4 )
end

FFLib.VGUI:Register('Button', PANEL)