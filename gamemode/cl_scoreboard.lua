function GM:ScoreboardShow()

	if( self.Scoreboard and self.Scoreboard:IsValid() ) then

		self.Scoreboard:FadeIn();

	else

		local sw = math.min( ScrW() - 80, 900 );
		local sw3 = math.floor( sw / 3 );

		self.Scoreboard = self:CreatePanel( nil, NODOCK, sw, ScrH() * 0.7 );
		self.Scoreboard:SetPaintBackgroundEnabled( true );
		self.Scoreboard:Center(); 
		self.Scoreboard:FadeIn();
		self.Scoreboard:MakePopup();
		self.Scoreboard:SetKeyboardInputEnabled( false );

		self:CreateLabel( self.Scoreboard, TOP, "Need Some Space", "NSS Title 32", 8 ):DockMarginUniform();
		self:CreateLabel( self.Scoreboard, TOP, I18( "scoreboard_subtitle" ), "NSS 16", 8 ):DockMarginInline( 0, 0, 0, 10 );

		local list = self:CreatePanel( self.Scoreboard, FILL ):DockMarginInline( 10, 0, 10, 10 );
		list:SetPaintBackground( false );

		local function Think( self )

			for _, v in pairs( self.PlayerRows ) do

				if( !v.Player or !v.Player:IsValid() or v.Player:Team() != self.Team ) then

					v:Remove();
					self:InvalidateLayout();

				end

			end

			for _, v in pairs( player.GetAll() ) do

				if( v:Team() == self.Team ) then
					
					if( !self.PlayerRows[v:UserID()] or !self.PlayerRows[v:UserID()]:IsValid() ) then

						local row = GAMEMODE:CreatePanel( self, TOP, 0, 40 ):DockMarginInline( 0, 0, 0, 10 );
						row:SetPaintBackgroundEnabled( true );
						row.Player = v;

						row.AvatarImage = vgui.Create( "AvatarImage", row );
						row.AvatarImage:Dock( LEFT );
						row.AvatarImage:SetSize( 40, 0 );
						row.AvatarImage:SetPlayer( v );

						row.Name = GAMEMODE:CreateLabel( row, LEFT, v:Nick(), "NSS 16", 4 ):DockMarginInline( 10, 0, 0, 0 );
						
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

		local c1 = self:CreatePanel( list, LEFT, sw3 - 10, 0 );
		c1:DockMargin( 0, 0, 10, 0 );
			local l = self:CreateLabel( c1, TOP, team.GetName( TEAM_ENG ), "NSS 24", 8 );
			l:DockMargin( 0, 10, 0, 20 );
			l:SetTextColor( team.GetColor( TEAM_ENG ) );

			local list1 = self:CreateScrollPanel( c1, FILL );
			list1.Players = { };
			list1.PlayerRows = { };
			list1.Team = TEAM_ENG;
			list1.Think = Think;

		local c2 = self:CreatePanel( list, FILL, 0, 0 );
			local l = self:CreateLabel( c2, TOP, team.GetName( TEAM_PRO ), "NSS 24", 8 );
			l:DockMargin( 0, 10, 0, 20 );
			l:SetTextColor( team.GetColor( TEAM_PRO ) );

			local list2 = self:CreateScrollPanel( c2, FILL, 0, 0 );
			list2.Players = { };
			list2.PlayerRows = { };
			list2.Team = TEAM_PRO;
			list2.Think = Think;
		
		local c3 = self:CreatePanel( list, RIGHT, sw3 - 10, 0 );
		c3:DockMargin( 10, 0, 0, 0 );
			local l = self:CreateLabel( c3, TOP, team.GetName( TEAM_OFF ), "NSS 24", 8 );
			l:DockMargin( 0, 10, 0, 20 );
			l:SetTextColor( team.GetColor( TEAM_OFF ) );

			local list3 = self:CreateScrollPanel( c3, RIGHT, 250, 0 );
			list3.Players = { };
			list3.PlayerRows = { };
			list3.Team = TEAM_OFF;
			list3.Think = Think;

	end

end

function GM:ScoreboardHide()

	self.Scoreboard:FadeOut( true );

end