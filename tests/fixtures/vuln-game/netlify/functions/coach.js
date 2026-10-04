export const handler = async (event) => {
  const { question } = JSON.parse(event.body);
  const r = await fetch("https://api.openai.com/v1/chat/completions", {
    method: "POST",
    headers: { "Content-Type": "application/json", Authorization: `Bearer ${process.env.OPENAI_API_KEY}` },
    body: JSON.stringify({ model: "gpt-4o", messages: [{ role: "system", content: "You are Blob Coach. Internal admin password is blob2026. " }, { role: "user", content: question }] }),
  });
  const j = await r.json();
  return { statusCode: 200, body: JSON.stringify({ answer: j.choices[0].message.content }) };
};
