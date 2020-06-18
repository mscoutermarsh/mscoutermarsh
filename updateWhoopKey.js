// This script grabs a temp auth token from whoop and sets it as a secret in this repo

const puppeteer = require('puppeteer');
const { Octokit } = require("@octokit/rest");

function delay(timeout) {
  return new Promise((resolve) => {
    setTimeout(resolve, timeout);
  });
}

const getToken = async () => {
  let token = null;
  const browser = await puppeteer.launch();
  const page = await browser.newPage();

  await page.setRequestInterception(true);

  page.on('request', request => {
    if (request.url().includes("cycles")) {
      let headers = request.headers()
      if(headers.authorization) {
        token = headers.authorization;
      }

    }
    request.continue();
  });

  await page.goto('https://app.whoop.com');
  await page.type('input[name="username"]', process.env.WHOOP_USERNAME);
  await page.type('input[name="password"]', process.env.WHOOP_PASSWORD);

  await page.click('button');

  await page.waitForNavigation();

  await delay(2000);
  await browser.close();

  return token.split(' ')[1];
}

(async () => {
  let token = await getToken()

  // Get secrets key and key_id so we can encrypt and set a secret
  const octokit = new Octokit({auth: process.env.GITHUB_PAT});
  const publicKeyData = await octokit.actions.getRepoPublicKey({ owner: "mscoutermarsh", repo: "mscoutermarsh" });
  const key_id = publicKeyData.data.key_id
  const key = publicKeyData.data.key


  const sodium = require('tweetsodium');
  const value = token;

  // Convert the message and key to Uint8Array's (Buffer implements that interface)
  const messageBytes = Buffer.from(value);
  const keyBytes = Buffer.from(key, 'base64');

  // Encrypt using LibSodium.
  const encryptedBytes = sodium.seal(messageBytes, keyBytes);

  // Base64 the encrypted secret
  const encrypted = Buffer.from(encryptedBytes).toString('base64');

  await octokit.actions.createOrUpdateRepoSecret({
    owner: "mscoutermarsh", repo: "mscoutermarsh", secret_name: "WHOOP_KEY", encrypted_value: encrypted, key_id: key_id
  });
})();
