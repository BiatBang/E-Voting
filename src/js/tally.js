var contractAddress = "0x0d62bb1c36cf062c4d91f25b2fc8d7500391bfe7";
/*
    {
        number: 1,
        voter: 111,
        candidate: 111
    },...
*/
var votes = [];

$(function () {
    $(window).load(function () {
        App.init();
    });

    $('#tallyBtn').on('click', function () {
        tally();
    })

    $('#verifyBtn').on('click', function () {
        verify();
    })
})

function verify() {
    getTransactionsByAccount(App.account);
    getVoteFromVotes(App.account);

}

function getVoteFromVotes(myaccount) {
    console.log(votes.length)
    votes.forEach((vote) => {
        console.log(vote);
        if (vote.voter == myaccount) {
            $('#verifyRes').text("Your vote's index: " + vote.count + ".\n You voted for: " + vote.candidate);
        }
    })
}

function getTransactionsByAccount(myaccount) {
    let startBlockNumber = 0;
    let endBlockNumber = 0;
    web3.eth.getBlockNumber((err, i) => {
        endBlockNumber = i;
        startBlockNumber = i - 1000;
        console.log("current block: ", i);

        for (let i = endBlockNumber; i >= startBlockNumber && i >= 0; i--) {
            if (i % 1000 == 0) {
                console.log("Searching block " + i);
            }
            web3.eth.getBlock(i, true, (err, res) => {
                var block = res;
                if (block != null && block.transactions != null) {
                    block.transactions.forEach(function (e) {
                        //  && e.to == contractAddress && e.input.length > 10
                        if (myaccount == e.from && e.input.length > 10) {
                            // console.log("  tx hash          : " + e.hash + "\n"
                            //     + "   nonce           : " + e.nonce + "\n"
                            //     + "   blockHash       : " + e.blockHash + "\n"
                            //     + "   blockNumber     : " + e.blockNumber + "\n"
                            //     + "   transactionIndex: " + e.transactionIndex + "\n"
                            //     + "   from            : " + e.from + "\n"
                            //     + "   to              : " + e.to + "\n"
                            //     + "   value           : " + e.value + "\n"
                            //     + "   time            : " + block.timestamp + " " + new Date(block.timestamp * 1000).toGMTString() + "\n"
                            //     + "   gasPrice        : " + e.gasPrice + "\n"
                            //     + "   gas             : " + e.gas + "\n"
                            //     + "   input           : " + e.input);
                            // console.log("time: ", new Date(block.timestamp * 1000).toGMTString());
                            let resultStr = "Your vote hash in blockchain: " + e.hash + ".\n The vote is valid at: " + new Date(block.timestamp * 1000).toGMTString();
                            $('#chainRes').text(resultStr);
                            return false;
                        }
                    })
                }
            });

        }

    });
}

function tally() {
    $('#tallyTable').empty();
    $('#voteTable').empty();

    $('#tallyTable').append("<thead><tr><th>candidate</th><th>count</th></tr></thead>");
    $('#voteTable').append("<thead><tr><th>voteId</th><th>voter</th><th>candidate</th></tr></thead>");

    var electionInstance;
    /*
        candidates: []
        [
            {
                id: 1,
                count: 1,
                addresses: ["11111111111"]
            }, ...
        ]    
    */
    App.contracts.Election.deployed().then(function (instance) {
        electionInstance = instance;
        return electionInstance.tally();
    }).then(res => {
        // return electionInstance.res();
        return electionInstance.candidatesCount();
    }).then(function (res) {
        var data = {
            datasets: [{
                data: []
            }],

            // These labels appear in the legend and in the tooltips when hovering different arcs
            labels: [
                'Alice',
                'Bob',
                'Charlie',
                'Daisy'
            ]
        };
        for (let i = 1; i <= res; i++) {
            var voteCount = 0;
            electionInstance.getCandidateNumVotes.call(i).then(count => {
                let tRow = "<tr>" +
                    "<td>" + i +
                    "</td>" +
                    "<td>" + parseInt(count) +
                    "</td>" +
                    "</tr>";
                data.push(count);
                $('#tallyTable').append(tRow);
                for (let j = 0; j < count; j++) {
                    electionInstance.queryVotes.call(i, j).then(address => {
                        votes.push({ count: ++voteCount, voter: address, candidate: i });
                        let vRow = "<tr><td>" + (voteCount) + "</td><td>" + address + "</td><td>" + i + "</td></tr>";
                        $('#voteTable').append(vRow);
                    })
                }
            });
        }
        var myPieChart = new Chart(ctx, {
            type: 'pie',
            data: data,
            // options: options
        });
    })
}

function showTally(candidates) {
    var candTable = $('#tallyTable');
    var voteTable = $('#voteTable');
    console.log(candidates[0])
    $.each(candidates, candidate => {
        let tRow = "<tr>" +
            "<td>" + candidate.id +
            "</td>" +
            "<td>" + candidate.count +
            "</td>" +
            "</tr>"
        tallyTable.append(tRow);

        $.each(candidate.addresses, add => {
            let vRow = "<tr><td>" + add + "</td><td>" + candidate.id + "</td></tr>"
            voteTable.append(vRow);
        })
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