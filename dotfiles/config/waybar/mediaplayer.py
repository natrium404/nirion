#!/usr/bin/env python3

import sys
import json
import signal
import logging
import argparse

import gi

gi.require_version('Playerctl', '2.0')
from gi.repository import Playerctl, GLib


# ──────────────────────────────── Logger Setup ────────────────────────────────
logger = logging.getLogger(__name__)


# ─────────────────────────────── Output Handling ──────────────────────────────
def write_output(text, player, hidden=False):
    logger.info('Writing output')

    player_name = player.props.player_name.capitalize() if player else ''

    output = {
        'text': text or 'Not Playing Anything',
        'class': 'hidden' if hidden else f'custom-{player.props.player_name}',
        'alt': player_name,
    }

    sys.stdout.write(json.dumps(output) + '\n')
    sys.stdout.flush()


# ─────────────────────────────── Callbacks ────────────────────────────────────
def on_play(player, status, manager):
    logger.info('Received new playback status')

    if status == 'Stopped':
        logger.info('Player has stopped')
        write_output('', player, hidden=True)
    else:
        on_metadata(player, player.props.metadata, manager)


def on_metadata(player, metadata, manager):
    logger.info('Received new metadata')

    track_info = ''

    # Check for Spotify ad
    if (
        player.props.player_name == 'spotify'
        and 'mpris:trackid' in metadata.keys()
        and ':ad:' in metadata['mpris:trackid']
    ):
        track_info = 'AD PLAYING'

    elif player.get_artist() and player.get_title():
        track_info = f'{player.get_title()} - {player.get_artist()}'

    else:
        track_info = player.get_title()

    # Add icon based on status
    if track_info:
        icon = '' if player.props.status == 'Playing' else ''
        track_info = f'{icon}  {track_info}'

    write_output(track_info, player)


def on_player_appeared(manager, player, selected_player=None):
    if player and (selected_player is None or player.name == selected_player):
        init_player(manager, player)
    else:
        logger.debug(
            "New player appeared, but it's not the selected player, skipping"
        )


def on_player_vanished(manager, player):
    logger.info('Player has vanished')
    sys.stdout.write('\n')
    sys.stdout.flush()


# ─────────────────────────────── Initialization ───────────────────────────────
def init_player(manager, player_name):
    logger.debug(f'Initialize player: {player_name.name}')
    player = Playerctl.Player.new_from_name(player_name)

    player.connect('playback-status', on_play, manager)
    player.connect('metadata', on_metadata, manager)

    manager.manage_player(player)
    on_metadata(player, player.props.metadata, manager)


def signal_handler(sig, frame):
    logger.debug('Received signal to stop, exiting')
    sys.stdout.write('\n')
    sys.stdout.flush()
    sys.exit(0)


# ─────────────────────────────── Argument Parsing ─────────────────────────────
def parse_arguments():
    parser = argparse.ArgumentParser(
        description='Now Playing Info via Playerctl'
    )
    parser.add_argument(
        '-v',
        '--verbose',
        action='count',
        default=0,
        help='Increase verbosity level',
    )
    parser.add_argument(
        '--player', help='Filter a specific media player by name'
    )
    return parser.parse_args()


# ─────────────────────────────── Main Execution ───────────────────────────────
def main():
    arguments = parse_arguments()

    # Setup logging
    logging.basicConfig(
        stream=sys.stderr,
        level=logging.DEBUG,
        format='%(name)s %(levelname)s %(message)s',
    )
    logger.setLevel(max((3 - arguments.verbose) * 10, 0))
    logger.debug(f'Arguments received: {vars(arguments)}')

    # Setup Player Manager and Loop
    manager = Playerctl.PlayerManager()
    loop = GLib.MainLoop()

    manager.connect(
        'name-appeared',
        lambda *args: on_player_appeared(*args, arguments.player),
    )
    manager.connect('player-vanished', on_player_vanished)

    # Signal handling for graceful shutdown
    signal.signal(signal.SIGINT, signal_handler)
    signal.signal(signal.SIGTERM, signal_handler)

    # Initialize existing players
    for player in manager.props.player_names:
        if arguments.player and arguments.player != player.name:
            logger.debug(f'{player.name} is not the filtered player, skipping')
            continue

        init_player(manager, player)

    loop.run()


if __name__ == '__main__':
    main()
