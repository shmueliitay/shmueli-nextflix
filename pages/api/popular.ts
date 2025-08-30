import type { NextApiRequest, NextApiResponse } from 'next';

export default async function handler(
  request: NextApiRequest,
  response: NextApiResponse
) {
  try {
    // Example fetch call (replace with your own logic)
    const res = await fetch(
      `https://api.themoviedb.org/3/movie/popular?api_key=${process.env.TMDB_API_KEY}`
    );
    const data = await res.json();

    response.status(200).json(data);
  } catch (error: any) {
    console.error(error?.data || error?.message || error);
    response.status(500).json({
      type: 'Error',
      data: error?.data || error?.message || error,
    });
  }
}

