import { streamText, stepCountIs } from "ai";
import { ollama } from "ai-sdk-ollama";
import { createMCPClient } from "@ai-sdk/mcp";
import { SYSTEM_PROMPT } from "@/lib/system-prompt";

export const maxDuration = 60;

export async function POST(req: Request) {
  const { messages } = await req.json();

  const mcpClient = await createMCPClient({
    transport: {
      type: "sse",
      url: process.env.SUPABASE_MCP_URL!,
    },
  });

  try {
    const tools = await mcpClient.tools();

    const result = streamText({
      model: ollama(process.env.OLLAMA_MODEL || "qwen3:8b"),
      system: SYSTEM_PROMPT,
      messages,
      tools,
      stopWhen: stepCountIs(5),
      onFinish: async () => {
        await mcpClient.close();
      },
      onError: async () => {
        await mcpClient.close();
      },
    });

    return result.toUIMessageStreamResponse();
  } catch (error) {
    await mcpClient.close();
    throw error;
  }
}
