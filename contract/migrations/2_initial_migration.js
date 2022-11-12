const Courses = artifacts.require("./Courses.sol");

module.exports = function(deployer) {
  deployer.deploy(Courses);
};
