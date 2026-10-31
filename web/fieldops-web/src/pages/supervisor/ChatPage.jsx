import { useEffect, useState, useRef } from 'react';
import { supabase } from '../../lib/supabase';
import { useAuth } from '../../hooks/useAuth';
import { 
  MessageSquare, Send, Radio, Users, Search, 
  Clock, Check, CheckCheck, AlertCircle 
} from 'lucide-react';
import toast from 'react-hot-toast';

export default function ChatPage() {
  const { staff } = useAuth();
  const [conversations, setConversations] = useState([]);
  const [activePartner, setActivePartner] = useState(null); // 'broadcast' or staff object
  const [messages, setMessages] = useState([]);
  const [inputText, setInputText] = useState('');
  const [isSending, setIsSending] = useState(false);
  const [search, setSearch] = useState('');
  const messagesEndRef = useRef(null);

  useEffect(() => {
    loadStaffList();
  }, []);

  useEffect(() => {
    if (!activePartner) return;
    loadMessages();

    // Subscribe to realtime messages
    const channel = supabase.channel(`web-chat-${activePartner.id || 'broadcast'}`)
      .on('postgres_changes', {
        event: 'INSERT',
        schema: 'public',
        table: 'messages',
      }, payload => {
        const newMsg = payload.new;
        if (activePartner === 'broadcast' && newMsg.is_broadcast) {
          setMessages(prev => [...prev, newMsg]);
        } else if (
          (newMsg.sender_id === activePartner.id && newMsg.receiver_id === staff?.id) ||
          (newMsg.sender_id === staff?.id && newMsg.receiver_id === activePartner.id)
        ) {
          setMessages(prev => [...prev, newMsg]);
        }
      })
      .subscribe();

    return () => {
      channel.unsubscribe();
    };
  }, [activePartner]);

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages]);

  async function loadStaffList() {
    const { data } = await supabase
      .from('staff')
      .select('id, name, name_mr, department, role, employee_id')
      .neq('id', staff?.id || '')
      .eq('is_active', true)
      .order('name');

    setConversations(data || []);
    // Default to broadcast channel
    setActivePartner('broadcast');
  }

  async function loadMessages() {
    try {
      if (activePartner === 'broadcast') {
        const { data } = await supabase
          .from('messages')
          .select('*, sender:sender_id(id, name, name_mr, role)')
          .eq('is_broadcast', true)
          .order('created_at', { ascending: true })
          .limit(100);
        setMessages(data || []);
      } else {
        const myId = staff?.id;
        const partnerId = activePartner.id;
        const { data } = await supabase
          .from('messages')
          .select('*, sender:sender_id(id, name, name_mr, role)')
          .or(`and(sender_id.eq.${myId},receiver_id.eq.${partnerId}),and(sender_id.eq.${partnerId},receiver_id.eq.${myId})`)
          .order('created_at', { ascending: true })
          .limit(100);
        setMessages(data || []);
      }
    } catch (_) {}
  }

  async function handleSendMessage(e) {
    e.preventDefault();
    if (!inputText.trim() || isSending) return;

    setIsSending(true);
    const isBroadcast = activePartner === 'broadcast';

    try {
      const { error } = await supabase.from('messages').insert({
        sender_id: staff?.id,
        receiver_id: isBroadcast ? null : activePartner.id,
        content: inputText.trim(),
        is_broadcast: isBroadcast,
        created_at: new Date().toISOString(),
      });

      if (error) throw error;
      setInputText('');
    } catch (err) {
      toast.error('Failed to send message: ' + err.message);
    } finally {
      setIsSending(false);
    }
  }

  const filteredStaff = conversations.filter(s =>
    !search ||
    s.name?.toLowerCase().includes(search.toLowerCase()) ||
    s.department?.toLowerCase().includes(search.toLowerCase()) ||
    s.employee_id?.toLowerCase().includes(search.toLowerCase())
  );

  return (
    <div className="flex h-[calc(100vh-1rem)] m-2 bg-white rounded-2xl border border-gray-200 overflow-hidden shadow-sm">
      {/* Left Sidebar - Chat & Broadcast List */}
      <div className="w-80 border-r border-gray-200 flex flex-col bg-gray-50/50">
        <div className="p-4 border-b border-gray-200 bg-white">
          <div className="flex items-center justify-between mb-3">
            <h1 className="text-lg font-bold text-gray-900 flex items-center gap-2">
              <MessageSquare className="text-primary" size={20} />
              Messages
            </h1>
            <span className="text-[10px] bg-primary-surface text-primary font-bold px-2 py-0.5 rounded-full">
              LIVE
            </span>
          </div>
          <div className="relative">
            <Search size={14} className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" />
            <input
              value={search}
              onChange={e => setSearch(e.target.value)}
              placeholder="Search field staff..."
              className="w-full pl-9 pr-3 py-1.5 text-xs bg-gray-50 border border-gray-200 rounded-xl focus:outline-none focus:border-primary"
            />
          </div>
        </div>

        <div className="flex-1 overflow-y-auto divide-y divide-gray-100">
          {/* Official Broadcast Channel */}
          <button
            onClick={() => setActivePartner('broadcast')}
            className={`w-full text-left p-3.5 flex items-center gap-3 transition-colors ${
              activePartner === 'broadcast' ? 'bg-primary-surface border-l-4 border-primary' : 'hover:bg-gray-100/70'
            }`}
          >
            <div className="w-10 h-10 rounded-full bg-orange-100 text-orange-700 flex items-center justify-center flex-shrink-0">
              <Radio size={20} />
            </div>
            <div className="min-w-0 flex-1">
              <div className="flex items-center justify-between">
                <p className="text-xs font-bold text-gray-900">Ward Broadcast 📢</p>
                <span className="text-[10px] text-orange-600 font-semibold bg-orange-50 px-1.5 py-0.2 rounded">All Staff</span>
              </div>
              <p className="text-[11px] text-gray-500 truncate mt-0.5">Send message to all ward field staff</p>
            </div>
          </button>

          {/* Individual Staff List */}
          <div className="px-3 py-2 text-[11px] font-bold text-gray-400 uppercase tracking-wider">
            Field Staff ({filteredStaff.length})
          </div>

          {filteredStaff.map(s => {
            const isSelected = activePartner?.id === s.id;
            return (
              <button
                key={s.id}
                onClick={() => setActivePartner(s)}
                className={`w-full text-left p-3 flex items-center gap-3 transition-colors ${
                  isSelected ? 'bg-primary-surface border-l-4 border-primary' : 'hover:bg-gray-100/70'
                }`}
              >
                <div className="w-9 h-9 rounded-full bg-primary/10 text-primary flex items-center justify-center text-xs font-bold flex-shrink-0">
                  {s.name?.charAt(0) || 'S'}
                </div>
                <div className="min-w-0 flex-1">
                  <div className="flex items-center justify-between">
                    <p className="text-xs font-semibold text-gray-900 truncate">{s.name_mr || s.name}</p>
                    <span className="text-[10px] text-gray-400">#{s.employee_id}</span>
                  </div>
                  <p className="text-[11px] text-gray-500 truncate">{s.department} · {s.role}</p>
                </div>
              </button>
            );
          })}
        </div>
      </div>

      {/* Right Chat Canvas */}
      <div className="flex-1 flex flex-col bg-white">
        {activePartner ? (
          <>
            {/* Chat Room Header */}
            <div className="px-6 py-3.5 border-b border-gray-200 flex items-center justify-between bg-gray-50/50">
              <div className="flex items-center gap-3">
                <div className={`w-9 h-9 rounded-full flex items-center justify-center font-bold text-xs ${
                  activePartner === 'broadcast' 
                    ? 'bg-orange-100 text-orange-700' 
                    : 'bg-primary-surface text-primary'
                }`}>
                  {activePartner === 'broadcast' ? <Radio size={18} /> : activePartner.name?.charAt(0)}
                </div>
                <div>
                  <h2 className="text-sm font-bold text-gray-900">
                    {activePartner === 'broadcast' ? 'Ward Broadcast Channel' : (activePartner.name_mr || activePartner.name)}
                  </h2>
                  <p className="text-[11px] text-gray-500">
                    {activePartner === 'broadcast' 
                      ? 'Messages delivered to all field personnel in active wards' 
                      : `${activePartner.department} · Employee ID: ${activePartner.employee_id}`}
                  </p>
                </div>
              </div>
            </div>

            {/* Message Stream */}
            <div className="flex-1 p-6 overflow-y-auto space-y-3 bg-[#F8FAF8]">
              {messages.length === 0 ? (
                <div className="h-full flex flex-col items-center justify-center text-gray-400">
                  <MessageSquare size={48} className="mb-2 opacity-30" />
                  <p className="text-xs">No messages yet. Send an announcement or direct instruction.</p>
                </div>
              ) : (
                messages.map((m, idx) => {
                  const isMe = m.sender_id === staff?.id;
                  const isBroadcast = m.is_broadcast;

                  return (
                    <div
                      key={m.id || idx}
                      className={`flex flex-col ${isMe ? 'items-end' : 'items-start'}`}
                    >
                      <div
                        className={`max-w-[70%] p-3.5 rounded-2xl text-xs space-y-1 shadow-sm ${
                          isBroadcast
                            ? 'bg-orange-50 border border-orange-200 text-orange-950'
                            : isMe
                              ? 'bg-primary text-white rounded-br-none'
                              : 'bg-white border border-gray-200 text-gray-900 rounded-bl-none'
                        }`}
                      >
                        {!isMe && (
                          <p className="text-[10px] font-bold opacity-75">
                            {m.sender?.name_mr || m.sender?.name || 'Staff'} {isBroadcast && '• [BROADCAST]'}
                          </p>
                        )}
                        <p className="text-sm leading-relaxed whitespace-pre-wrap">{m.content}</p>
                        <div className={`flex items-center justify-end gap-1 text-[10px] ${isMe ? 'text-white/70' : 'text-gray-400'}`}>
                          <span>{new Date(m.created_at || m.sent_at).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</span>
                          {isMe && <CheckCheck size={12} />}
                        </div>
                      </div>
                    </div>
                  );
                })
              )}
              <div ref={messagesEndRef} />
            </div>

            {/* Input Bar */}
            <form onSubmit={handleSendMessage} className="p-3 border-t border-gray-200 bg-white flex items-center gap-2">
              <input
                type="text"
                value={inputText}
                onChange={e => setInputText(e.target.value)}
                placeholder={
                  activePartner === 'broadcast'
                    ? 'Type broadcast announcement for all field staff...'
                    : `Message ${activePartner.name}...`
                }
                className="flex-1 px-4 py-2.5 text-xs bg-gray-50 border border-gray-200 rounded-xl focus:outline-none focus:border-primary"
              />
              <button
                type="submit"
                disabled={!inputText.trim() || isSending}
                className="bg-primary hover:bg-primary-dark disabled:opacity-50 text-white px-5 py-2.5 rounded-xl text-xs font-semibold flex items-center gap-1.5 transition-all shadow-sm"
              >
                <Send size={14} /> Send
              </button>
            </form>
          </>
        ) : (
          <div className="h-full flex items-center justify-center text-gray-400 text-xs">
            Select a conversation to begin
          </div>
        )}
      </div>
    </div>
  );
}
