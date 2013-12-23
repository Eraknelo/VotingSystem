JC2-MP - Voting system
===

Network events
---

<h3>Subscribable</h3>

<table>
  <tr>
    <td>Name</td>
    <td>VoteHandlerVoteStarted</td>
  </tr>
  <tr>
    <td>Description</td>
    <td>Triggers when a new vote is started.</td>
  </tr>
  <tr>
    <td>Arguments</td>
    <td>
      <table>
        <tr>
          <td>topic</td>
          <td>string</td>
        </tr>
        <tr>
          <td>duration</td>
          <td>string</td>
        </tr>
        <tr>
          <td>options</td>
          <td>table[id, text]</td>
        </tr>
      </table>
    </td>
  </tr>
</table>

<table>
  <tr>
    <td>Name</td>
    <td>VoteHandlerCurrentVote</td>
  </tr>
  <tr>
    <td>Description</td>
    <td>Sent by server, if there's currently an active vote, after calling Network:Send("VoteHandlerCancelVote")</td>
  </tr>
  <tr>
    <td>Arguments</td>
    <td>
      <table>
        <tr>
          <td>topic</td>
          <td>string</td>
        </tr>
        <tr>
          <td>duration</td>
          <td>string</td>
        </tr>
        <tr>
          <td>options</td>
          <td>table[id, text]</td>
        </tr>
      </table>
    </td>
  </tr>
</table>

<table>
  <tr>
    <td>Name</td>
    <td>VoteHandlerVoteCancelled</td>
  </tr>
  <tr>
    <td>Description</td>
    <td>Triggered when the vote is cancelled.</td>
  </tr>
  <tr>
    <td>Arguments</td>
    <td>
      <table>
        <tr>
          <td>topic</td>
          <td>string</td>
        </tr>
        <tr>
          <td>duration</td>
          <td>string</td>
        </tr>
        <tr>
          <td>results</td>
          <td>table[option id, option votes]</td>
        </tr>
      </table>
    </td>
  </tr>
</table>

<table>
  <tr>
    <td>Name</td>
    <td>VoteHandlerVoteEnded</td>
  </tr>
  <tr>
    <td>Description</td>
    <td>Triggered when the vote has ended.</td>
  </tr>
  <tr>
    <td>Arguments</td>
    <td>
      <table>
        <tr>
          <td>topic</td>
          <td>string</td>
        </tr>
        <tr>
          <td>duration</td>
          <td>string</td>
        </tr>
        <tr>
          <td>results</td>
          <td>table[option id, option votes]</td>
        </tr>
      </table>
    </td>
  </tr>
</table>

<h3>Sendable</h3>

<table>
  <tr>
    <td>Name</td>
    <td>VoteHandlerCreateVote</td>
  </tr>
  <tr>
    <td>Description</td>
    <td>Creates a vote.</td>
  </tr>
  <tr>
    <td>Arguments</td>
    <td>
      <table>
        <tr>
          <td>player</td>
          <td>Player</td>
        </tr>
        <tr>
          <td>topic</td>
          <td>string</td>
        </tr>
        <tr>
          <td>options</td>
          <td>table[string]</td>
        </tr>
        <tr>
          <td>duration</td>
          <td>integer (seconds)</td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td>Example</td>
    <td>
      <blockquote>Network:Send("VoteHandlerCreateVote", {player = LocalPlayer, topic = "Test vote", options = {"A", "B", "C"}, duration = 5})</blockquote>
      Starts a vote that runs for 5 seconds with the topic "Test vote" and the options "A", "B" and "C"
    </td>
  </tr>
</table>

<table>
  <tr>
    <td>Name</td>
    <td>VoteHandlerGetCurrentVote</td>
  </tr>
  <tr>
    <td>Description</td>
    <td>Gets the current active vote, and returns it in the subscribalbe "VoteHandlerCurrentVote" event.</td>
  </tr>
  <tr>
    <td>Arguments</td>
    <td>
    </td>
  </tr>
  <tr>
    <td>Example</td>
    <td>
      <blockquote>Network:Send("VoteHandlerGetCurrentVote")</blockquote>
    </td>
  </tr>
</table>

<table>
  <tr>
    <td>Name</td>
    <td>VoteHandlerPlayerVote</td>
  </tr>
  <tr>
    <td>Description</td>
    <td>Sets a vote on the current active vote.</td>
  </tr>
  <tr>
    <td>Arguments</td>
    <td>
      <table>
        <tr>
          <td>player</td>
          <td>Player</td>
        </tr>
        <tr>
          <td>option</td>
          <td>int (option ID)</td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td>Example</td>
    <td>
      <blockquote>Network:Send("VoteHandlerPlayerVote", {player = LocalPlayer, option = 1})</blockquote>
      Make the current player vote for option 1.
    </td>
  </tr>
</table>

<table>
  <tr>
    <td>Name</td>
    <td>VoteHandlerCancelVote</td>
  </tr>
  <tr>
    <td>Description</td>
    <td>Cancel the current active vote.</td>
  </tr>
  <tr>
    <td>Arguments</td>
    <td>
    </td>
  </tr>
  <tr>
    <td>Example</td>
    <td>
      <blockquote>Network:Send("VoteHandlerCancelVote")</blockquote>
    </td>
  </tr>
</table>
