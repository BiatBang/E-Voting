$(function () {
    $(window).load(function () {
        App.init();
        var tallyTable = $('#tallyTable');
        tallyTable.append("<tr>hello</tr>")
    });



    $('#tallyBtn').on('click', function () {
        tally();
    })
})

function tally() {
    var electionInstance;
    App.contracts.Election.deployed().then(function (instance) {
        electionInstance = instance;
        return electionInstance.tally();
    }).then(res => {
        // return electionInstance.res();
        return electionInstance.candidatesCount();
    }).then(function (res) {
        console.log(res);
        let candidates = [];
        for (let i = 1; i <= res; i++) {
            electionInstance.getCandidateNumVotes.call(i).then(count => {
                let cand = {};
                cand.id = i;
                cand.count = count;
                let adds = [];
                for (let j = 0; j < count; j++) {
                    electionInstance.queryVotes.call(i, j).then(address => {
                        adds.push(address);
                    })
                }
                cand.addresses = adds;
                candidates.push(cand);
            });
        }

    })
}

App = {
    web3Provider: null,
    contracts: {},
    account: '0x0',
    hasVoted: false,

    init: function () {
        return App.initWeb3();
    },

    initWeb3: function () {
        // TODO: refactor conditional
        if (typeof web3 !== 'undefined') {
            // If a web3 instance is already provided by Meta Mask.
            App.web3Provider = web3.currentProvider;
            web3 = new Web3(web3.currentProvider);
        } else {
            // Specify default instance if no web3 instance provided
            App.web3Provider = new Web3.providers.HttpProvider('http://127.0.0.1:7545');
            web3 = new Web3(App.web3Provider);
        }
        return App.initContract();
    },

    initContract: function () {
        $.getJSON("Election.json", function (election) {
            // Instantiate a new truffle contract from the artifact
            App.contracts.Election = TruffleContract(election);
            // Connect provider to interact with contract
            App.contracts.Election.setProvider(App.web3Provider);

            return App.render();
        });
    },

    render: function () {
        var electionInstance;
        // Load account data
        web3.eth.getCoinbase(function (err, account) {
            if (err === null) {
                App.account = account;
            } else console.error(err)
        })
    }
}