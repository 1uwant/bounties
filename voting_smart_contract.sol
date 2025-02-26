// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Voting {
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    struct Voter {
        bool registered;
        bool voted;
        uint votedCandidateId;
    }

    address public owner;
    bool public votingStarted;
    bool public votingEnded;

    mapping(address => Voter) public voters;
    mapping(uint => Candidate) public candidates;
    uint public candidateCount;

    event CandidateRegistered(uint candidateId, string name);
    event VoterRegistered(address voter);
    event Voted(address voter, uint candidateId);
    event VotingStarted();
    event VotingEnded();
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can perform this action");
        _;
    }

    modifier onlyBeforeVoting() {
        require(!votingStarted, "Action not allowed after voting has started");
        _;
    }

    modifier onlyDuringVoting() {
        require(votingStarted && !votingEnded, "Voting is not active");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function registerCandidate(string memory _name) public onlyOwner onlyBeforeVoting {
        candidateCount++;
        candidates[candidateCount] = Candidate(candidateCount, _name, 0);
        emit CandidateRegistered(candidateCount, _name);
    }

    function registerVoter(address _voter) public onlyOwner onlyBeforeVoting {
        require(!voters[_voter].registered, "Voter is already registered");
        voters[_voter] = Voter(true, false, 0);
        emit VoterRegistered(_voter);
    }

    function startVoting() public onlyOwner onlyBeforeVoting {
        require(candidateCount > 0, "No candidates registered");
        votingStarted = true;
        emit VotingStarted();
    }

    function vote(uint _candidateId) public onlyDuringVoting {
        require(voters[msg.sender].registered, "You are not registered to vote");
        require(!voters[msg.sender].voted, "You have already voted");
        require(_candidateId > 0 && _candidateId <= candidateCount, "Invalid candidate");

        voters[msg.sender].voted = true;
        voters[msg.sender].votedCandidateId = _candidateId;
        candidates[_candidateId].voteCount++;

        emit Voted(msg.sender, _candidateId);
    }

    function endVoting() public onlyOwner onlyDuringVoting {
        votingEnded = true;
        emit VotingEnded();
    }

    function getWinner() public view returns (string memory winnerName, uint winnerVoteCount) {
        require(votingEnded, "Voting has not ended yet");

        uint maxVotes = 0;
        uint winningCandidateId = 0;

        for (uint i = 1; i <= candidateCount; i++) {
            if (candidates[i].voteCount > maxVotes) {
                maxVotes = candidates[i].voteCount;
                winningCandidateId = i;
            }
        }

        return (candidates[winningCandidateId].name, maxVotes);
    }

    function getCandidate(uint _candidateId) public view returns (string memory name, uint votes) {
        require(_candidateId > 0 && _candidateId <= candidateCount, "Invalid candidate ID");
        return (candidates[_candidateId].name, candidates[_candidateId].voteCount);
    }
}
