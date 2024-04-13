import * as fs from 'fs';
import { utils } from "ethers";

import { ethers } from 'ethers';


function generateRandomAddress():string| null {
  try {
    const wallet = ethers.Wallet.createRandom();
    return wallet.address;
  } catch (error) {
    console.error("Error generating random address:", error);
    return null; // Handle errors or return null on failure
  }
}


// Generate 500 addresses and token IDs and different balances
function generateData(): { address: string|null, tokenID: number, amount : number }[] {
    const data = [];
    for (let i = 1; i <= 500; i++) {
       
        const bal = Math.ceil(Math.random() * i * 30)
    
        data.push({ address: generateRandomAddress(), tokenID: i, amount: bal });
    }
    
    
    return data;
}

// Function to convert data to CSV format
function convertToCSV(data: { address: string|null, tokenID: number, amount : number }[]): string {
    let csv = 'address,tokenID,amount\n';
    data.forEach(item => {
        csv += `${item.address},${item.tokenID},${item.amount}\n`;
    });
    return csv;
}

// Write data to a CSV file
function writeCSV(data: string): void {
    fs.writeFile('data.csv', data, (err) => {
        if (err) {
            console.error('Error writing to CSV:', err);
        } else {
            console.log('CSV file generated successfully.');
        }
    });
}

// Main function to generate data and write to CSV
function main() {
    const data = generateData();
    const csvData = convertToCSV(data);
    writeCSV(csvData);
}

// Run the main function
main();