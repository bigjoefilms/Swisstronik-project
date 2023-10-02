const hre = require("hardhat");
const { encryptDataField, decryptNodeResponse } = require("@swisstronik/swisstronik.js");

const sendShieldedTransaction = async (signer, destination, data, value) => {
  const rpclink = hre.network.config.url;
  const [encryptedData] = await encryptDataField(rpclink, data);
  return await signer.sendTransaction({
    from: signer.address,
    to: destination,
    data: encryptedData,
    value,
  });
};

async function main() {
  const contractAddress = "0x41a7E1Eeba329C49352775aDf7b6a2fAE886194d";
  const [signer] = await hre.ethers.getSigners();
  const contractFactory = await hre.ethers.getContractFactory("VotingSystem");
  const contract = contractFactory.attach(contractAddress);
  const functionName = "registerCandidate";
  const messageToSet = "8";
  const messageToSets = "Abanobi";
  const setMessageTx = await sendShieldedTransaction(signer, contractAddress, contract.interface.encodeFunctionData(functionName, [messageToSet,messageToSets]), 0);
  await setMessageTx.wait();
  console.log("Transaction Receipt: ", setMessageTx);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});