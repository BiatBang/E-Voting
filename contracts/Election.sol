pragma solidity ^0.5.16;


contract Election {
    // store the candidates
    // provide reading and writing

    // model a candidate
    struct Candidate {
        // unsigned integer
        uint256 id;
        string name;
        uint256 voteCount;
        string content;
        address add;
    }

    struct Voter {
        address add;
        bool hasVoted;
        uint256 candidateId;
    }

    struct Vote {
        address voter;
        uint256 candidateId;
    }

    struct Record {
        uint256 candidate;
        address[] voters;
        uint256 count;
    }

    // key => value to store the candidates
    mapping(uint256 => Candidate) public candidates;

    // Store accounts that have voted
    mapping(address => Voter) public voters;
    mapping(address => bool) public validVoters;

    mapping(uint256 => Record) public records;

    // to count the number, since mapping has no function of counting
    // brutely
    uint256 public candidatesCount;
    uint256 public validVotersCount;

    Vote[] votes;

    // Record[] public result;

    // constraint the range of candidates
    constructor() public {
        addCandidate("Alice", "I've got you in my sights.");
        addCandidate("Bob", "It's high noon.");
        addCandidate("Charlie", "Justice rains from above.");
        addCandidate("Daisy", "Meteor Strike!");

        buildValidVoters();
    }

    function buildValidVoters() private {
        address add = address(0x1111111111111111111111111111111111111111);
        validVoters[add] = true;
    }

    function buildVoter(address add) public {
        if (voters[add].add == address(0))
            voters[add] = Voter(add, false, 100000);
    }

    // here memory is mandatory to tell the location of the parameter
    function addCandidate(string memory _name, string memory _content) private {
        candidatesCount++;
        address add = address(this);
        candidates[candidatesCount] = Candidate(
            candidatesCount,
            _name,
            0,
            _content,
            add
        );
    }

    // voted event
    event votedEvent(uint256 indexed _candidateId);

    function vote(uint256 _candidateId) public {
        address voter = msg.sender;
        // check if the voter has voted
        require(!voters[voter].hasVoted, "you have voted");
        require(validVoters[voter], "not valid voter");

        // // check if the candidate is valid
        require(
            _candidateId > 0 && _candidateId <= candidatesCount,
            "invalid candidate"
        );

        // vote for a candidate and update its count
        candidates[_candidateId].voteCount++;

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
        // clear clear clear
        for (uint256 i = 1; i <= candidatesCount; i++) {
            delete records[i];
        }

        for (uint256 i = 0; i < votes.length; i++) {
            if (!validVoters[votes[i].voter]) continue;
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
    function getCandidateNumVotes(uint256 candidateId)
        public
        view
        returns (uint256)
    {
        return records[candidateId].count;
    }

    function queryVotes(uint256 candidateId, uint256 index)
        public
        view
        returns (address)
    {
        return records[candidateId].voters[index];
    }
}
