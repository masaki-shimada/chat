<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Events\MessageSent;
use App\Models\Message;
use App\Models\User;
use Pusher\Pusher;

class ChatController extends Controller
{
    private $request;
    private $user;
    private $message;

    public function __construct(Request $request, User $user, Message $message)
    {
        $this->request = $request;
        $this->user = $user;
        $this->message = $message;
    }

    public function index(Request $request)
    {
        return view('chat.index');
    }

    public function list()
    {
        return view('chat.list');
    }

    public function getUsers()
    {
        return $this->user->friends($this->request->user()->id)->get();
    }

    public function room(int $user_id)
    {
        return view('chat.room');
    }

    public function fetchMessages(Request $request)
    {
        return Message::with('user')->get();
    }

    public function sendMessage(Request $request)
    {
        $user = $request->user();

        $message = $user->messages()->create([
            'message' => $request->input('message')
        ]);

        MessageSent::dispatch($user, $message);

        //return ['status' => 'Message Sent!'];
    }

}
