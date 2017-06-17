function GM:ScoreboardShow()

	if( self.Scoreboard and self.Scoreboard:IsValid() ) then

		self.Scoreboard:FadeIn();

	else

		self.Scoreboard = self:CreatePanel( nil, NODOCK, 500, ScrH() * 0.7 );
		self.Scoreboard:SetPaintBackgroundEnabled( true );
		self.Scoreboard:Center(); 
		self.Scoreboard:FadeIn();
		self.Scoreboard:MakePopup();
		self.Scoreboard:SetKeyboardInputEnabled( false );

		self:CreateLabel( self.Scoreboard, TOP, "Need Some Space", "NSS Title 32", 8 ):DockMarginUniform();
		self:CreateLabel( self.Scoreboard, TOP, "By disseminate", "NSS 16", 8 ):DockMarginInline( 0, 0, 0, 10 );

		local list = self:CreateScrollPanel( self.Scoreboard, FILL ):DockMarginInline( 10, 0, 10, 10 );
		list.Players = { };
		list.PlayerRows = { };

		function list:Think()

			for _, v in pairs( self.PlayerRows ) do

				if( !v.Player or !v.Player:IsValid() ) then

					v:Remove();
					self:InvalidateLayout();

				end

			end

			for _, v in pairs( player.GetAll() ) do

				if( !self.PlayerRows[v:UserID()] or !self.PlayerRows[v:UserID()]:IsValid() ) then

					local row = GAMEMODE:CreatePanel( self, TOP, 0, 40 ):DockMarginInline( 0, 0, 0, 10 );
					row:SetPaintBackgroundEnabled( true );
					row.Player = v;

					row.AvatarImage = vgui.Create( "AvatarImage", row );
					row.AvatarImage:Dock( LEFT );
					row.AvatarImage:SetSize( 40, 0 );
					row.AvatarImage:SetPlayer( v );

					row.Name = GAMEMODE:CreateLabel( row, LEFT, v:Nick(), "NSS 20", 4 ):DockMarginInline( 10, 0, 0, 0 );
					
					local i = self:GetSkin().ICON_AUDIO_ON;
					if( v:IsMuted() ) then
						i = self:GetSkin().ICON_AUDIO_OFF;
					end
					row.MuteBut = GAMEMODE:CreateIconButton( row, RIGHT, 32, 0, i, function( b )
						
						v:SetMuted( !v:IsMuted() );

						local i = self:GetSkin().ICON_AUDIO_ON;
						if( v:IsMuted() ) then
							i = self:GetSkin().ICON_AUDIO_OFF;
						end

						b:SetIcon( i );
						
					end ):DockMarginInline( 4, 4, 4, 4 );

					row.Ping = GAMEMODE:CreateLabel( row, RIGHT, v:Ping(), "NSS 16", 6 ):DockMarginInline( 10, 0, 10, 0 );

					function row:Think()

						if( self.Name:GetText() != self.Player:Nick() ) then

							self.Name:SetText( self.Player:Nick() );
							self.Name:SizeToContents();

							self:InvalidateLayout();

						end

						if( self.Name:GetTextColor() != team.GetColor( self.Player:Team() ) ) then
							self.Name:SetTextColor( team.GetColor( self.Player:Team() ) );
						end

						if( self.Ping:GetText() != self.Player:Ping() ) then

							self.Ping:SetText( self.Player:Ping() );
							self.Ping:SizeToContents();

							self:InvalidateLayout();

						end

					end

					self.PlayerRows[v:UserID()] = row;

				end

			end

		end

	end

end

function GM:ScoreboardHide()

	self.Scoreboard:FadeOut();

end