"use client";

import { useState } from "react";
import { openContractCall, showConnect } from "@stacks/connect";
import { STACKS_MAINNET } from "@stacks/network";
import { AnchorMode, PostConditionMode } from "@stacks/transactions";

const CONTRACT_ADDRESS = "SP3E0DQAHTXJHH5YT9TZCSBW013YXZB25QFDVXXWY";
const CONTRACT_NAME = "lottery";

export default function Lottery() {
  const [address, setAddress] = useState<string | null>(null);
  const [txId, setTxId] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  const connectWallet = () => {
    showConnect({
      appDetails: { name: "Stacks Lottery", icon: "/logo.png" },
      onFinish: () => {
        const userData = JSON.parse(localStorage.getItem("blockstack-session") || "{}");
        setAddress(userData?.userData?.profile?.stxAddress?.mainnet || null);
      },
      userSession: undefined,
    });
  };

  const buyTicket = async () => {
    setLoading(true);
    try {
      await openContractCall({
        network: STACKS_MAINNET,
        anchorMode: AnchorMode.Any,
        contractAddress: CONTRACT_ADDRESS,
        contractName: CONTRACT_NAME,
        functionName: "buy-ticket",
        functionArgs: [],
        postConditionMode: PostConditionMode.Allow,
        onFinish: (data) => {
          setTxId(data.txId);
          setLoading(false);
        },
        onCancel: () => setLoading(false),
      });
    } catch (error) {
      console.error(error);
      setLoading(false);
    }
  };

  return (
    <main className="min-h-screen bg-gradient-to-br from-yellow-500 to-orange-600 text-white p-8">
      <div className="max-w-lg mx-auto text-center">
        <h1 className="text-5xl font-bold mb-4">🎰 Stacks Lottery</h1>
        <p className="text-xl mb-8">Buy tickets. Win big. On-chain.</p>

        {!address ? (
          <button
            onClick={connectWallet}
            className="bg-white text-orange-600 px-8 py-4 rounded-lg font-bold text-xl hover:bg-gray-100"
          >
            Connect Wallet
          </button>
        ) : (
          <div className="space-y-6">
            <div className="bg-white/20 p-4 rounded-lg">
              <p className="text-sm">Connected: {address.slice(0, 8)}...{address.slice(-4)}</p>
            </div>

            <div className="bg-white/20 p-8 rounded-xl">
              <h2 className="text-2xl font-bold mb-4">🎟️ Ticket Price: 1 STX</h2>
              <button
                onClick={buyTicket}
                disabled={loading}
                className="w-full bg-white text-orange-600 py-4 rounded-lg font-bold text-xl hover:bg-gray-100 disabled:opacity-50"
              >
                {loading ? "Buying..." : "Buy Ticket"}
              </button>
            </div>

            {txId && (
              <div className="bg-green-500/30 p-4 rounded-lg">
                <p className="font-bold">Ticket Purchased!</p>
                <a
                  href={`https://explorer.hiro.so/txid/${txId}?chain=mainnet`}
                  target="_blank"
                  className="underline text-sm"
                >
                  View Transaction
                </a>
              </div>
            )}
          </div>
        )}
      </div>
    </main>
  );
}
