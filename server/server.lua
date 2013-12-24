class 'Vote'

function Vote:__init(player, topic, options, duration)
	self.textColor = Color(255, 0, 0)
	
	self.player = player
	self.topic = topic
	self.options = options
	self.duration = duration
	
	self.votes = {}
	self.tickSubscription = nil
	self.timer = nil
end

function Vote:SetVote(player, option)
	local chosenOption = self.options[option]
	
	if chosenOption == nil then -- Chosen option does not exist in lsit of options
		Chat:Send(player, "The chosen option is not valid.", Color(255, 0, 0))
		return
	end
	
	if player == nil or not IsValid(player) then return end -- Somehow, the player is nil
	
	local playerId = player:GetSteamId().id -- Get player ID
	if playerId == nil then return end -- Somehow, the player Steam id is nil
	
	self.votes[playerId] = chosenOption
end

function Vote:Start()
	Network:Broadcast("VoteHandlerVoteStarted", {topic = self.topic, duration = self.duration, options = self.options})
	self.timer = Timer()
	self.tickSubscription = Events:Subscribe("PostTick", self, self.PostTick)
end

function Vote:Cancel()
	if self.tickSubscription ~= nil then Events:Unsubscribe(self.tickSubscription) end
end

function Vote:PostTick(args)
	if self.timer == nil or self.timer:GetSeconds() < self.duration then return end -- No timer or vote still running
	
	if self.tickSubscription ~= nil then Events:Unsubscribe(self.tickSubscription) end -- Voting time elapsed, unsubscribe tick
	
	Events:Fire("VoteHandlerVotingEnded", {player = self.player, topic = self.topic, options = self.options, duration = self.duration})
end

function Vote:GetResults()
	local results = {}
	for index, option in pairs(self.options) do results[option] = 0 end

	for voter, option in pairs(self.votes) do
		results[option] = results[option] + 1
	end
	
	return results
end

function Vote.ParseVote(args)
	local player = args.player
	local topic = args.topic
	local options = args.options
	local duration = args.duration
	
	-- No player
	if player == nil then return end
	
	-- No topic
	if topic == nil then
		Chat:Send(player, "The topic has not been given.", self.textColorError)
		return
	end
	
	-- No options
	if options == nil then
		Chat:Send(player, "The options have not been given.", self.textColorError)
		return
	end
	
	-- No duration
	if duration == nil then
		Chat:Send(player, "The duration has not been given.", self.textColorError)
		return
	end
	
	return Vote(player, topic, options, duration)
end

class 'VoteHandler'

function VoteHandler:__init()
	self.textColorError = Color(255, 0, 0)
	self.textColorSuccess = Color(255, 0, 0)
	self.currentVote = nil
	
	Events:Subscribe("VoteHandlerVotingEnded", self, self.VotingEnded)

	Network:Subscribe("VoteHandlerCreateVote", self, self.CreateVote)
	Network:Subscribe("VoteHandlerCancelVote", self, self.CancelVote)
	Network:Subscribe("VoteHandlerPlayerVote", self, self.PlayerVote)
	Network:Subscribe("VoteHandlerGetCurrentVote", self, self.GetCurrentVote)
end

-- Local events
function VoteHandler:VotingEnded(args)
	-- Parse vote class
	local vote = Vote.ParseVote(args)
	if vote == nil then return end
	
	Network:Broadcast("VoteHandlerVoteEnded", {topic = vote.topic, duration = vote.duration, results = vote:GetResults()})
	self.currentVote = nil
end

-- Networked events
function VoteHandler:CreateVote(args)
	-- Parse vote class
	local vote = Vote.ParseVote(args)
	if vote == nil then return end
	
	-- Vote in progress
	if self.currentVote ~= nil then
		Chat:Send(vote.player, "Vote already in progress.", self.textColorError)
		return
	end
	
	-- Create vote
	self.currentVote = vote
	self.currentVote:Start()
end

function VoteHandler:CancelVote()
	if self.currentVote == nil then return end
	
	self.currentVote:Cancel()
	Network:Broadcast("VoteHandlerVoteCancelled", {topic = self.currentVote.topic, duration = self.currentVote.duration, results = self.currentVote:GetResults()})
	self.currentVote = nil
end

function VoteHandler:PlayerVote(args)
	if self.currentVote == nil then return end

	local player = args.player
	local option = args.option
	
	self.currentVote:SetVote(player, option)
end

function VoteHandler:GetCurrentVote(args, player)
	print("Get current")
	if self.currentVote == nil then return end

	Network:Broadcast("VoteHandlerCurrentVote", {topic = self.currentVote.topic, duration = self.currentVote.duration, options = self.currentVote.options})
end

-- Initialize vote handler
local voteHandler = VoteHandler()