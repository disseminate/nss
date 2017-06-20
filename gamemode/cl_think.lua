function GM:Think()

	self:StateThink();
	self:SubsystemThink();
	self:TerminalSolveThink();
	self:WorkbenchThink();

end
