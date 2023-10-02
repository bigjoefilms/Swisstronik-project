// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSystem {
    address private owner;
    uint256 public totalVotes;

    struct Voter {
        bool isRegistered;
        bool hasVoted;
    }

    struct Candidate {
        string name;
        uint256 voteCount;
    }

    struct Vote {
        address voterAddress;
        uint256 candidateId;
    }

    mapping(address => Voter) public voters;
    mapping(uint256 => Candidate) public candidates;
    Vote[] public votes; // Store all votes cast

    event VoterRegistered(address indexed voterAddress);
    event VoteCasted(address indexed voterAddress, uint256 candidateId);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can perform this action");
        _;
    }

    modifier onlyRegisteredVoter() {
        require(voters[msg.sender].isRegistered, "Only registered voters can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function registerVoter(address _voterAddress) public onlyOwner {
        require(!_isRegisteredVoter(_voterAddress), "Voter is already registered");
        voters[_voterAddress].isRegistered = true;
        emit VoterRegistered(_voterAddress);
    }

    function registerCandidate(uint256 _candidateId, string memory _name) public onlyOwner {
        require(!_isRegisteredCandidate(_candidateId), "Candidate ID already exists");
        candidates[_candidateId] = Candidate(_name, 0);
    }

    function vote(uint256 _candidateId) public onlyRegisteredVoter {
        require(!_hasVoted(msg.sender), "You have already voted");
        require(_isRegisteredCandidate(_candidateId), "Invalid candidate ID");

        candidates[_candidateId].voteCount++;
        voters[msg.sender].hasVoted = true;
        totalVotes++;

        // Store the vote
        votes.push(Vote({
            voterAddress: msg.sender,
            candidateId: _candidateId
        }));

        emit VoteCasted(msg.sender, _candidateId);
    }

//   function getWinner() public view returns (uint256 winningCandidateId, string memory winningCandidateName) {
//     require(totalVotes > 0, "No votes have been cast yet");

//     winningCandidateId = 1; // Initialize with the first candidate
//     uint256 maxVotes = candidates[1].voteCount;

//     for (uint256 i = 2; i <= /* replace with the actual number of candidates */; i++) {
//         if (candidates[i].voteCount > maxVotes) {
//             winningCandidateId = i;
//             maxVotes = candidates[i].voteCount;
//         }
//     }

//     winningCandidateName = candidates[winningCandidateId].name;
// }

    function getAllVotes() public view returns (Vote[] memory) {
        return votes;
    }

    function _isRegisteredVoter(address _address) private view returns (bool) {
        return voters[_address].isRegistered;
    }

    function _hasVoted(address _address) private view returns (bool) {
        return voters[_address].hasVoted;
    }

    function _isRegisteredCandidate(uint256 _candidateId) private view returns (bool) {
        return bytes(candidates[_candidateId].name).length > 0;
    }
}
