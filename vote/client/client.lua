class 'VoteHandler'

function VoteHandler:__init()
	Network:Subscribe("VoteHandlerVoteStarted", self, self.VoteStarted)
	Network:Subscribe("VoteHandlerCurrentVote", self, self.CurrentVote)
	Network:Subscribe("VoteHandlerVoteCancelled", self, self.VoteCancelled)
	Network:Subscribe("VoteHandlerVoteEnded", self, self.VoteEnded)
	
	Network:Send("VoteHandlerCreateVote", {player = LocalPlayer, topic = "Test vote", options = {"A", "B", "C"}, duration = 5})
end

function VoteHandler:VoteStarted(args)
	local topic = args.topic
	local duration = args.duration
	local options = args.options
	
	print("started", topic, duration)
	
	Network:Send("VoteHandlerGetCurrentVote")
	Network:Send("VoteHandlerPlayerVote", {player = LocalPlayer, option = 1})
	Network:Send("VoteHandlerCancelVote")
end

function VoteHandler:CurrentVote(args)
	local topic = args.topic
	local duration = args.duration
	local options = args.options
	
	print("current", topic, duration)
	
	for optionId, option in pairs(options) do
		print("Vote option: " .. optionId .. " text: " .. option)
	end
end

function VoteHandler:VoteCancelled(args)
	local topic = args.topic
	local duration = args.duration
	local results = args.results
	
	print("cancelled", topic, duration)
	
	for option, votes in pairs(results) do
		print("Vote result: " .. option .. " votes: " .. votes)
	end
end

function VoteHandler:VoteEnded(args)
	local topic = args.topic
	local duration = args.duration
	local results = args.results
	
	print("ended", topic, duration)
	
	for option, votes in pairs(results) do
		print("Vote result: " .. option .. " votes: " .. votes)
	end
end

local voteHandler = VoteHandler()