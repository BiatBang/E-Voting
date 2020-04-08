var Election =  artifacts.require('./Election.sol');

contract("Election", accounts => {
    it("init with 2 cands", () => {
        return Election.deployed().then(i => {
            return i.candidatesCount();
        }).then(count => {
            assert.equal(count, 2);
        })
    });

    // 52:48 another test
})

contract("Election", accounts => {
    it("init with 2 cands", () => {
        return Election.deployed().then(i => {
            return i.candidatesCount();
        }).then(count => {
            assert.equal(count, 2);
        })
    });

    // 52:48 another test
})