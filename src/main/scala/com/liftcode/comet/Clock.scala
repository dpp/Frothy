/*
 * Clock.scala
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.liftcode.comet

import net.liftweb._
import http._
import js._
import JsCmds._
import JE._
import util._
import Helpers._

class Clock extends CometActor {

  override def localSetup() {
    super.localSetup()
    ActorPing.schedule(this, 'Ping , 3 seconds)
  }

  override def highPriority = {
    case 'Ping =>
      partialUpdate(currentTime)
      ActorPing.schedule(this, 'Ping , 3 seconds)
  }

  def currentTime: JsCmd = JsRaw("clockCallback("+(""+now).encJs+");")

  def render = {
    val str: String = """var f = function() {try {"""+(currentTime.toJsCmd)+"""} catch (e) {setTimeout(f, 50);}}; f();"""
    OnLoad(JsRaw(str))
  }
}
