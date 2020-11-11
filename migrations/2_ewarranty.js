const EWarranty = artifacts.require("EWarranty");

module.exports = function (deployer) {
    deployer.deploy(EWarranty, "Samsung", "samsung.com");
};