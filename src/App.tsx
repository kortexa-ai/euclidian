import { useState } from "react";
//import { invoke } from "@tauri-apps/api/core";
import { OpenAI } from "openai";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Avatar, AvatarImage } from "@/components/ui/avatar";

interface ChatMessage {
  id: number;
  text: string;
  isUser: boolean;
}

export function App() {
  const [messages, setMessages] = useState<ChatMessage[]>([]);
  const [input, setInput] = useState("");

  const shapesInc = new OpenAI({
    apiKey: import.meta.env.VITE_SHAPESINC_API_KEY,
    baseURL: "https://api.shapes.inc/v1/",
    dangerouslyAllowBrowser: true,
  });

  async function sendMessage() {
    if (!input.trim()) return;

    // Add user message to chat
    const userMessage: ChatMessage = {
      id: messages.length,
      text: input,
      isUser: true,
    };
    setMessages([...messages, userMessage]);
    setInput("");

    try {
      // Commented out original greet invoke
      // const response: string = await invoke("greet", { name: input });

      // Call OpenAI API
      const completion = await shapesInc.chat.completions.create({
        model: 'shapesinc/' + import.meta.env.VITE_SHAPESINC_SHAPE_USERNAME,
        messages: [{ role: 'user', content: input }],
      });

      const aiResponse = completion.choices[0]?.message?.content || "No response";
      setMessages([
        ...messages,
        userMessage,
        { id: messages.length + 1, text: aiResponse, isUser: false },
      ]);
    } catch (error) {
      console.error("Error calling OpenAI:", error);
      setMessages([
        ...messages,
        userMessage,
        {
          id: messages.length + 1,
          text: "Error: Could not get response",
          isUser: false,
        },
      ]);
    }
  }

  return (
    <main className="min-h-screen flex items-center justify-center bg-gray-100 p-4">
      <Card className="w-full max-w-md shadow-lg flex flex-col h-[500px]">
        <CardHeader className="text-center">
          <CardTitle className="text-2xl font-bold text-gray-900">
            Euclidian Chat
          </CardTitle>
        </CardHeader>
        <CardContent className="flex-1 flex flex-col gap-4 overflow-hidden">
          <div className="flex justify-center">
            <a href="https://shapes.inc" target="_blank" rel="noopener noreferrer">
              <Avatar className="w-16 h-16">
                <AvatarImage
                  src="/shapes_inc.png"
                  alt="Shapes Inc logo"
                  className="object-contain"
                />
              </Avatar>
            </a>
          </div>
          <div className="flex-1 overflow-y-auto space-y-2 px-2">
            {messages.map((msg) => (
              <div
                key={msg.id}
                className={`p-2 rounded-lg text-sm max-w-[80%] ${msg.isUser
                    ? "bg-blue-500 text-white ml-auto"
                    : "bg-gray-50 text-gray-700 mr-auto"
                  }`}
              >
                {msg.text}
              </div>
            ))}
          </div>
          <form
            className="flex gap-2"
            onSubmit={(e) => {
              e.preventDefault();
              sendMessage();
            }}
          >
            <Input
              id="chat-input"
              value={input}
              onChange={(e) => setInput(e.currentTarget.value)}
              placeholder="Type a message..."
              className="flex-1"
            />
            <Button type="submit" className="w-20">
              Send
            </Button>
          </form>
        </CardContent>
      </Card>
    </main>
  );
}