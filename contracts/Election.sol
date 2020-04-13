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
        address add = address(0x6Ae87b602153F81FA71c66096a03123b694Ac0e4);
        validVoters[add] = true;
        add = address(0xEF030ce53211c33462af5e28Ec4eb9782F22bA41);
        validVoters[add] = true;
        add = address(0xd16544E2ACbc4cB972EA989ED73021128E338135);
        validVoters[add] = true;
        add = address(0x2f1A0e41Ba6D9E92137454A771297a27632DF366);
        validVoters[add] = true;
        add = address(0x9105bfD7F13615b666eFe174721802bB9512EC90);
        validVoters[add] = true;
        add = address(0xf0d0710bA94879F255978E9EEe5d56c246aeDC15);
        validVoters[add] = true;
        add = address(0x547fD53fa73363A966683FEA9981C8E8F7b0838b);
        validVoters[add] = true;
        add = address(0x6F3fE9e79c8E3A4409E96d64EB2298c049C1E867);
        validVoters[add] = true;
        add = address(0x47D00C0aEcB819126cB700C51CaF794D9581d09E);
        validVoters[add] = true;
        add = address(0xe8A72e83FAFA2ED57aA01Eda5150E8201159fa09);
        validVoters[add] = true;
        add = address(0xb7ef045baE3a3c259756A5bC15d8e92cC0b52363);
        validVoters[add] = true;
        add = address(0xDD9E027E9FeDa75653569c52D5A2509C4d5ABF0a);
        validVoters[add] = true;
        add = address(0xf904a246960Ee3AA72BEc4ac97Cb301927d9210d);
        validVoters[add] = true;
        add = address(0x5d18755f843B0EBc71100E8E13AE5ECA014f22e6);
        validVoters[add] = true;
        add = address(0x16e851A324B9bC34C72Bdad6E3eAe7fccb844a92);
        validVoters[add] = true;
        add = address(0xF2a031A0D7228158883e3D37fC9132E80672c38b);
        validVoters[add] = true;
        add = address(0x126E65B236C6B1A4e20d6a5e28e57F3BD2B654CD);
        validVoters[add] = true;
        add = address(0x6C62EFE273a095a6Cda3a3FA0D87382912143782);
        validVoters[add] = true;
        add = address(0x8aFe720d01F3047e0CB8d9B6c5C9d1f32116df5f);
        validVoters[add] = true;
        add = address(0x50E179f88bd171Ae636cC9b7Ba897D31d50e5FB5);
        validVoters[add] = true;
        add = address(0x043F3873eA4fF06de4fC0B1936CB2fA0994D4674);
        validVoters[add] = true;
        add = address(0x59f99fC18AcAb13cdD1B6A540899561D338654Bf);
        validVoters[add] = true;
        add = address(0x7BF9171c7B5ef818a1bC67bdb467F3bD5ea6cE0C);
        validVoters[add] = true;
        add = address(0x14665999426D7f15e0049a747C7603E7cF49A615);
        validVoters[add] = true;
        add = address(0xa736a1121bab5C20F2C1077251Fe1150e9BFaF87);
        validVoters[add] = true;
        add = address(0x7D89D151A5D33A28Ac2574808da26805AbB50fC3);
        validVoters[add] = true;
        add = address(0xD3b642AF04e0487c4cd702DEDe8e26aDf1DE5347);
        validVoters[add] = true;
        add = address(0xE18Aa59fb84ae53F588c01Ca4ed1E40A5e69Ce19);
        validVoters[add] = true;
        add = address(0x000Cd1998D3a806b71C875B160DD8417E1Ac717B);
        validVoters[add] = true;
        add = address(0xaA02BFd868A78a580F7E7E9C3A34dd174babd7F1);
        validVoters[add] = true;
        add = address(0x54eB0A374eba7314e55eE46f33F34EF832a79eb5);
        validVoters[add] = true;
        add = address(0x4c58a58B0aCF01883Ee61fe79a8A0327510656aB);
        validVoters[add] = true;
        add = address(0xdaE50C414489B210EEFE23799Be8F3C85741FC59);
        validVoters[add] = true;
        add = address(0x11926fA8ec87860c5Df52ddA2C343793b1b47151);
        validVoters[add] = true;
        add = address(0x217b4518dfB9EAE5aBFbDb18fF2ecb14F578D20b);
        validVoters[add] = true;
        add = address(0x0d64319Ef57297C0a083d00A105EC786bc1dF202);
        validVoters[add] = true;
        add = address(0x3ed3DCaE3b93337530961bfCaD849e3168Ac74C3);
        validVoters[add] = true;
        add = address(0xb8AFac104F2C51D2aBf302F4Aa93C5F374c9Ad08);
        validVoters[add] = true;
        add = address(0x54B269306A90393b5Ce24A7450d3322EA4c933C7);
        validVoters[add] = true;
        add = address(0x6f9837bA8D8b6Dfe7E0A46BC79c872079Ac94044);
        validVoters[add] = true;
        add = address(0xa4564b4745CC14C998e9d446362b5045fd4ee25B);
        validVoters[add] = true;
        add = address(0xaB47d7DeE3E8b1f74F6189AA216dB2fd8344a516);
        validVoters[add] = true;
        add = address(0x22Af238d722f2bE67a8BAb6573C8C12476aDfDF9);
        validVoters[add] = true;
        add = address(0x9996E4391c47e8Ba06bE8e4baD3d617AC0611B24);
        validVoters[add] = true;
        add = address(0x66cefad2eD7EdfB66FFC68f2abf00036afb32E79);
        validVoters[add] = true;
        add = address(0x6FD826430164eD7Da27BC7DdaE5C73537915a938);
        validVoters[add] = true;
        add = address(0x7B19584F1047E470D0D6AA932205679b3219bfC9);
        validVoters[add] = true;
        add = address(0x23f9A55BF7Ae8c4bc0976b8D61cae2251d567842);
        validVoters[add] = true;
        add = address(0x75F46fD18785b79638fC80B9defcF895dFC55e90);
        validVoters[add] = true;
        add = address(0x376DD9138Ed88965F65d4b6878B8F3ef16Fa81e9);
        validVoters[add] = true;
        add = address(0x9E4D9A6e6341b42D52039bf1cbade9B504A40E4F);
        validVoters[add] = true;
        add = address(0xa8a121c72e60A49fa73C1B5c62272ECFC189DBC2);
        validVoters[add] = true;
        add = address(0xe4C6E8C8e4c5CAf75eB4de3A35F5eE0fA1cd741D);
        validVoters[add] = true;
        add = address(0x2d25178fac5bc9320578b889f093f2Ca794a9edE);
        validVoters[add] = true;
        add = address(0x24f16B8241aA3892B377BD53DA6Fd7CC4EF9583F);
        validVoters[add] = true;
        add = address(0x8E0B7c046854510A9FF6ae0ad61800f7149812E2);
        validVoters[add] = true;
        add = address(0x0f9EdF8BbF66eC6fCf81ddae1b2EeFBaa7A0B144);
        validVoters[add] = true;
        add = address(0xAA24EdD38AD040414A7d53f3a370c1A5247A2b52);
        validVoters[add] = true;
        add = address(0xbb6F3B5b43c2a59f96313e092eA7dDDE0C492180);
        validVoters[add] = true;
        add = address(0x6c39569F534d74CBD711f5278d3d55A9afB663eA);
        validVoters[add] = true;
        add = address(0x7F71C256E5c98D9F5C0a8fe4F13Ba09DE6544D6C);
        validVoters[add] = true;
        add = address(0x50a06742f9bdfde13d380b6052D22510114c9eAa);
        validVoters[add] = true;
        add = address(0xC8f049937A96a119cFCC02388a3e2B0Ca057AE98);
        validVoters[add] = true;
        add = address(0x8cA9b8245Abb2De35ffFa704f540E9367eAe49Bc);
        validVoters[add] = true;
        add = address(0x4F20f9B85faFE7AaDF7e5710B5C1561DdaC03602);
        validVoters[add] = true;
        add = address(0xa4a1D6c1bB637abD0ef7026667D08bFe36fef5eB);
        validVoters[add] = true;
        add = address(0xc206d72c702A94b27D37eA1c14529B7BB1Ba70de);
        validVoters[add] = true;
        add = address(0xE9678A3c093e81D8bC97D3BFbAd019ba77C8ABDE);
        validVoters[add] = true;
        add = address(0x17234eb55895ebcF6B89ececC58040A0B96281e5);
        validVoters[add] = true;
        add = address(0xE6CeAf08A8E6c7DeDDb3f409f339d8b50F9FCE23);
        validVoters[add] = true;
        add = address(0x95759E2f9Fe83a7c9321Bc4D0bbFd40d58FF1355);
        validVoters[add] = true;
        add = address(0xfc0972307b477E50ECA741185363444Fb4888331);
        validVoters[add] = true;
        add = address(0xd00Cd9A524589E488c2294656bb852bEB888F13C);
        validVoters[add] = true;
        add = address(0xb574379EdDC1e4Ae27665da686235455142f567F);
        validVoters[add] = true;
        add = address(0x1ec225576882cDf7b46565BD79a6a0610E655338);
        validVoters[add] = true;
        add = address(0x8c4eF3f147A76AdCbB80AC68D99Fd833A755C65D);
        validVoters[add] = true;
        add = address(0x06B2fDf58C8cD8503C1C707c36eB593D34f90011);
        validVoters[add] = true;
        add = address(0x877293e4efFd12366e7d5171391Eb9e938Ef54eE);
        validVoters[add] = true;
        add = address(0xAf23D9173C01A8fDf0b23Be730AD946194cE25ae);
        validVoters[add] = true;
        add = address(0x7ecB35111732d1b8D1F8bA422D902581b6783a5F);
        validVoters[add] = true;
        add = address(0x0a5916b33996a2BD0441505eE9781b615cE3924f);
        validVoters[add] = true;
        add = address(0x88DC1347Ff233845Ae9aE3B4e537D6De140e5a94);
        validVoters[add] = true;
        add = address(0xC13cB55E57eb107f1aA4658C3b2f52D7Bf34B876);
        validVoters[add] = true;
        add = address(0xf5531e9C45F903f381479cB849509e2EC591E1F3);
        validVoters[add] = true;
        add = address(0x4b53e89378A7C239D80e7451Ea784f92572982d0);
        validVoters[add] = true;
        add = address(0x3BC1643E3747b2b8F313987Cff922dbB4C3A0f8e);
        validVoters[add] = true;
        add = address(0x01f3b898640db2BCC4FB84A407291c6F60D4EDaf);
        validVoters[add] = true;
        add = address(0xe736c13d6C07a08bc145A20F662b808885F0caE2);
        validVoters[add] = true;
        add = address(0xf31fF3d0880421aaea60eB14e9668f9Fea6E74C3);
        validVoters[add] = true;
        add = address(0x1f41BaBb0815dbe41cd2a3ec2033a80839e04286);
        validVoters[add] = true;

        // address add = address(0x6Ae87b602153F81FA71c66096a03123b694Ac0e4);
        // validVoters[add] = true;
        // add = address(0xEF030ce53211c33462af5e28Ec4eb9782F22bA41);
        // validVoters[add] = true;
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
