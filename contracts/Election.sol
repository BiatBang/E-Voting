pragma solidity ^0.5.16;

contract Election{
    // store the candidates
    // provide reading and writing

    // model a candidate
    struct Candidate {
        // unsigned integer
        uint id;
        string name;
        uint voteCount;
        string content;
        address add;
    }

    struct Voter {
        address add;
        bool hasVoted;
        uint candidateId;
    }

    struct Vote {
        address voter;
        uint candidateId;
    }

    struct Record {
        uint candidate;
        address[] voters;
        uint count;
    }

    // key => value to store the candidates
    mapping (uint => Candidate) public candidates;

    // Store accounts that have voted
    mapping (address => Voter) public voters;
    mapping (address => bool) public validVoters;

    mapping (uint => Record) public records;

    // to count the number, since mapping has no function of counting
    // brutely
    uint public candidatesCount;
    uint public validVotersCount;

    Vote[] votes;
    // Record[] public result;

    // constraint the range of candidates
    constructor() public {
        addCandidate("cand 1", "I can be the best mayor!");
        addCandidate("cand 2", "He's weak, trust me!");

        buildValidVoters();
        // validVoters.push("0x6Ae87b602153F81FA71c66096a03123b694Ac0e4");
    }

    function buildValidVoters() private {
        address a1 = address(0x6Ae87b602153F81FA71c66096a03123b694Ac0e4);
        validVoters[a1] = true;
        address a2 = address(0xEF030ce53211c33462af5e28Ec4eb9782F22bA41);
        validVoters[a2] = true;
        // validVoters[validVotersCount++] = "0x6Ae87b602153F81FA71c66096a03123b694Ac0e4";
    }

    function buildVoter(address add) public {
        if(voters[add].add == address(0)) voters[add] = Voter(add, false, 100000);
    }

    // here memory is mandatory to tell the location of the parameter
    function addCandidate(string memory _name, string memory _content) private {
        candidatesCount++;
        address add = address(this);
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0, _content, add);
    }

    // voted event
    event votedEvent (
        uint indexed _candidateId
    );

    function vote (uint _candidateId) public {
        address voter = msg.sender;
        // check if the voter has voted
        require(!voters[voter].hasVoted, "you have voted");
        require(validVoters[voter], "not valid voter");

        // // check if the candidate is valid
        require(_candidateId > 0 && _candidateId <= candidatesCount, "invalid candidate");

        // vote for a candidate and update its count
        candidates[_candidateId].voteCount ++;

        // record the voter has votes
        // how to know who's voter??? why should we know?
        // however this is the voter
        voters[voter].hasVoted = true;
        voters[voter].candidateId = _candidateId;

        votes.push(Vote(voter, _candidateId));

        // trigger voted event
        emit votedEvent(_candidateId);
    }

    function tally() public {
        for(uint i = 0; i < votes.length; i++) {
            if(!validVoters[votes[i].voter]) continue;
            records[votes[i].candidateId].count += 1;
            records[votes[i].candidateId].voters.push(votes[i].voter);
        }

    }

    /* a very detoured way
     * solidity doesn't support returning an array of struct
     * so this is a very brute way to return all the valid votes:
     * we give a getter of how many votes each candidate gather,
     * then we return to tally server one by one.
    */
    function getCandidateNumVotes(uint candidateId) public view returns (uint) {
        return records[candidateId].count;
    }

    function queryVotes(uint candidateId, uint index) public view returns (address) {
        return records[candidateId].voters[index];
    }
}