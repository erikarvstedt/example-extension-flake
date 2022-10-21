@test("tux-bitcoin")
def _():
    assert_running("tux-bitcoin")
    status = succeed("cat /var/lib/tux-bitcoin/status")
    assert "Chain" in status
