"use client";

import { useChat } from "@ai-sdk/react";
import { useState } from "react";

export default function Home() {
  const { messages, sendMessage, status, error } = useChat();
  const [input, setInput] = useState("");

  const isLoading = status === "submitted" || status === "streaming";

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!input.trim() || isLoading) return;
    const text = input;
    setInput("");
    await sendMessage({ text });
  };

  return (
    <div className="flex min-h-screen flex-col items-center bg-zinc-50 font-sans dark:bg-zinc-950">
      <div className="w-full max-w-3xl flex flex-col min-h-screen">
        {/* Header */}
        <header className="sticky top-0 z-10 border-b border-zinc-200 bg-white/80 backdrop-blur dark:border-zinc-800 dark:bg-zinc-950/80 px-6 py-4">
          <h1 className="text-xl font-semibold text-zinc-900 dark:text-zinc-100">
            Product Search
          </h1>
          <p className="text-sm text-zinc-500 dark:text-zinc-400">
            Ask me anything about our products — powered by local AI
          </p>
        </header>

        {/* Messages */}
        <div className="flex-1 overflow-y-auto px-6 py-6 space-y-4">
          {messages.length === 0 && (
            <div className="flex flex-col items-center justify-center h-full text-center py-20">
              <p className="text-zinc-400 dark:text-zinc-500 text-lg mb-4">
                Try searching for products:
              </p>
              <div className="space-y-2 text-sm text-zinc-500 dark:text-zinc-400">
                <p>&quot;Show me smartphones under $900&quot;</p>
                <p>&quot;What books do you have?&quot;</p>
                <p>&quot;Find Apple products&quot;</p>
                <p>&quot;Highest rated products in stock&quot;</p>
              </div>
            </div>
          )}

          {messages.map((message) => (
            <div
              key={message.id}
              className={`flex ${
                message.role === "user" ? "justify-end" : "justify-start"
              }`}
            >
              <div
                className={`max-w-[85%] rounded-2xl px-4 py-3 text-sm leading-relaxed whitespace-pre-wrap ${
                  message.role === "user"
                    ? "bg-zinc-900 text-white dark:bg-zinc-100 dark:text-zinc-900"
                    : "bg-white border border-zinc-200 text-zinc-800 dark:bg-zinc-900 dark:border-zinc-700 dark:text-zinc-200"
                }`}
              >
                {message.parts
                  .filter((part) => part.type === "text")
                  .map((part, i) => (
                    <span key={i}>{part.text}</span>
                  ))}
              </div>
            </div>
          ))}

          {isLoading && (
            <div className="flex justify-start">
              <div className="bg-white border border-zinc-200 dark:bg-zinc-900 dark:border-zinc-700 rounded-2xl px-4 py-3 text-sm text-zinc-400">
                <span className="inline-flex gap-1">
                  <span className="animate-bounce">.</span>
                  <span className="animate-bounce [animation-delay:0.1s]">
                    .
                  </span>
                  <span className="animate-bounce [animation-delay:0.2s]">
                    .
                  </span>
                </span>
              </div>
            </div>
          )}

          {error && (
            <div className="rounded-lg bg-red-50 dark:bg-red-950 border border-red-200 dark:border-red-800 px-4 py-3 text-sm text-red-700 dark:text-red-300">
              Error: {error.message}
            </div>
          )}
        </div>

        {/* Input */}
        <div className="sticky bottom-0 border-t border-zinc-200 bg-white/80 backdrop-blur dark:border-zinc-800 dark:bg-zinc-950/80 px-6 py-4">
          <form onSubmit={handleSubmit} className="flex gap-3">
            <input
              value={input}
              onChange={(e) => setInput(e.target.value)}
              placeholder="Search for products..."
              className="flex-1 rounded-xl border border-zinc-300 bg-white px-4 py-3 text-sm text-zinc-900 placeholder-zinc-400 outline-none focus:border-zinc-500 focus:ring-2 focus:ring-zinc-200 dark:border-zinc-700 dark:bg-zinc-900 dark:text-zinc-100 dark:placeholder-zinc-500 dark:focus:border-zinc-500 dark:focus:ring-zinc-800"
              disabled={isLoading}
            />
            <button
              type="submit"
              disabled={isLoading || !input.trim()}
              className="rounded-xl bg-zinc-900 px-5 py-3 text-sm font-medium text-white transition-colors hover:bg-zinc-700 disabled:opacity-40 disabled:cursor-not-allowed dark:bg-zinc-100 dark:text-zinc-900 dark:hover:bg-zinc-300"
            >
              Send
            </button>
          </form>
        </div>
      </div>
    </div>
  );
}
